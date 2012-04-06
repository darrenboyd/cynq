require "thor"
require 'colorize'
require 'cynq/local'
require 'cynq/remote'
require 'yaml'

module Cynq
  class Command < Thor
    desc "deploy REMOTE", "Upload files to REMOTE"
    method_option :dry_run, :type => :boolean, :aliases => "-n",
                    :default => false, :desc => 'Do not do anything.'
    def deploy(remote)
      load_config(remote)

      if options.dry_run?
        puts "  Dry run executing...".green
      end

      local  = Local.new(@local_root)
      remote = Remote.new(@remote['directory'])

      p local
      p remote

      keys = (local.keys + remote.keys).sort
      keys.each do |key|
        case
        when local.missing?(key)
          puts "  deleting #{key}".red
          remote.delete(key) unless options.dry_run?
        when remote.missing?(key)
          puts "    adding #{key}".green
          remote << local[key] unless options.dry_run?
        when remote.modified?(local[key])
          puts "  modified #{key}".magenta
          remote << local[key] unless options.dry_run?
        else
          puts " unchanged #{key}" unless options.dry_run?
        end
      end
    end

    no_tasks do
      def load_config(remote)
        conf_file = File.expand_path('cynq.yml')
        
        unless File.exist?(conf_file)
          $stderr.puts "Missing configuration file at #{conf_file}"
          raise "Configuration not found"
        end

        @config = YAML::load_file(conf_file)
        @local_root = File.expand_path(@config['local_root'])

        unless Dir.exist?(@local_root)
          $stderr.puts("The 'local_root' cannot be found: #{@local_root.to_s}")
          raise "Configuration is invalid"
        end

        @remote = @config['remotes'][remote]
        unless @remote
          $stderr.puts("No environment matching '#{remote}' can be found.")
          raise "Configuration is invalid"
        end
      end
    end
  end
end
