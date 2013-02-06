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
    method_option :config, :type => :string, :aliases => "-c",
                    :default => 'cynq.yml', :desc => 'The configuration file to load.'


    attr_reader :local_dir, :remote_dir


    def deploy(remote)
      load_config(remote)

      if options.dry_run?
        puts "  Dry run executing...".green
      end

      establish_roots

      all_keys.each do |key|
        case
        when local_dir.missing?(key)
          puts "  deleting #{key}".red
          remote_dir.delete(key) unless options.dry_run?
        when remote_dir.missing?(key)
          puts "    adding #{key} #{local_dir[key].content_type}".green
          remote_dir << local_dir[key] unless options.dry_run?
        when remote_dir.modified?(local_dir[key])
          puts "  modified #{key}".magenta
          remote_dir << local_dir[key] unless options.dry_run?
        when !remote_dir.meta_equal?(local_dir[key])
          puts "      meta #{key} #{local_dir[key].content_type}".white.on_magenta
          remote_dir << local_dir[key] unless options.dry_run?
        else
          puts " unchanged #{key}" unless options.dry_run?
        end
      end
    end

    no_tasks do

      def establish_roots
        p (@local_dir  = Local.new(@local_root))
        p (@remote_dir = Remote.new(@remote_root['directory']))
      end

      def all_keys
        (local_dir.keys + remote_dir.keys).sort
      end


      def load_config(remote)
        conf_file = File.expand_path(options.config)

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

        @remote_root = @config['remotes'][remote]
        unless @remote_root
          $stderr.puts("No environment matching '#{remote}' can be found.")
          raise "Configuration is invalid"
        end
      end
    end
  end
end
