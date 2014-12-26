class PortlandConfig
  class << self
    attr_accessor :env_config

    def load(config_file=nil)
      config_file ||= File.join(Rails.root, 'config', 'portland_config.yml')
      if File.file?(config_file)
        config = HashWithIndifferentAccess.new(YAML.load(ERB.new(File.new(config_file).read).result))
        @env_config = config[application_environment] || {}
      else
        raise Exception.new("Missing config file '#{config_file}'")
      end
    end

    def [](key)
      return @env_config[key]
    end

    def []=(key, value)
      @env_config[key] = value
    end

    def application_environment
      ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end
  end
  load
end
