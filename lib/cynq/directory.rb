require 'fog'
require 'mime/types'

module Cynq
  class Directory
    attr_reader :connection, :keys, :bucket

    def initialize(bucket_name)
      establish_connection
      find_bucket(bucket_name)
      read_current_files
    end

    def include?(key)
      keys.include?(key)
    end

    def missing?(key)
      ! include? key
    end

    def [](key)
      @current_files[key]
    end

    def <<(other_file)
      if file = self[other_file.key]
        file.body = other_file.body
      else
        file = @bucket.files.new({
          :key => other_file.key,
          :body => other_file.body
        })
        ct = content_type_for_key(other_file.key)
        file.content_type = ct if ct
      end
      file.public = true
      file.save
    end

    def delete(key)
      if file = self[key]
        file.destroy
      end
    end

    def modified?(other_file)
      other_file.etag != self[other_file.key].etag
    end

    def inspect
      "#{self.class.name}: #{@bucket.key} (#{keys.size} files, #{size} bytes)"
    end

    def size
      @current_files.values.inject(0) { |sum,file| sum + file.content_length }
    end

    def content_type_for_key(key)
      types = MIME::Types.type_for(File.extname(key))
      types.empty? ? nil : types.first.to_s
    end

    protected
    def find_bucket(bucket_name)
      @bucket = @connection.directories.get(bucket_name)
      raise "Bucket not found #{bucket_name}" unless @bucket
    end

    def read_current_files
      @current_files = @bucket.files.inject({}) do |hsh, file|
        hsh[file.key] = file
        hsh
      end
      @keys = Set.new(@current_files.keys)
    end
  end
end
