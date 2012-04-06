require 'cynq/directory'

module Cynq
  class Local < Directory

    def initialize(bucket_name)
      # We expect a directory for a Local storage.
      # However, we have to use the root of that
      # directory as the 'root', and then the name
      # of that directory as the bucket.
      bucket_name = File.expand_path(bucket_name)
      @local_root = File.dirname bucket_name
      super(File.basename bucket_name)
      require 'cynq/ext/fog'
    end

    protected
    def establish_connection
      @connection = Fog::Storage.new({
        :provider   => 'Local',
        :local_root => @local_root })
    end

  end
end
