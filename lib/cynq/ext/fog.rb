require 'digest'
require 'digest/md5'

module Cynq
  module LocalFileExtension
    def etag
      Digest::MD5.file(path).to_s
    end
  end
end

require 'fog/local/models/storage/file'
Fog::Storage::Local::File.send(:include, Cynq::LocalFileExtension)
