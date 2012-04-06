require 'cynq/directory'

module Cynq
  class Remote < Directory

    protected
    def establish_connection
      key, secret = ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']

      unless key && secret
        $stderr.puts %Q{
  AWS Keys are required to be in your environment.
  Please set the following, to the appropriate values...
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
}
        raise "Misconfigured AWS" 
      end

      @connection = Fog::Storage.new({
        :provider              => 'AWS',
        :aws_access_key_id     => key,
        :aws_secret_access_key => secret
      })
    end

  end
end
