require 'yaml'

module Revue
  # An object for returning config settings from YAML or the shell
  # environment.
  class Config
    # The file path for this configuration.
    attr_reader :path

    # The prefix for all ENV settings, so setting +$REVUE_USERNAME+ in
    # the shell will override the +Revue.config.username+ setting
    # out of YAML.
    PREFIX = 'REVUE'

    def initialize(from_path = 'config/application.yml')
      @path = File.expand_path(from_path)
    end

    def method_missing(method, *arguments)
      return super unless respond_to? method
      env["#{method}".upcase] || yaml["#{method}"]
    end

    def respond_to?(method)
      env.keys.include?(var(method)) || yaml.keys.include?(method.to_s) || super
    end

    private

    def env
      ENV
    end

    def yaml
      @yaml ||= YAML::load_file(path)
    end

    def var(method)
      [PREFIX, "#{method}".upcase].join('_')
    end
  end
end
