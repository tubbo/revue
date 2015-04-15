require 'revue/version'
require 'revue/model'
require 'revue/ticket'
require 'revue/pull_request'
require 'revue/server'
require 'revue/config'

module Revue
  class << self
    attr_accessor :config_path

    def server
      @server ||= Server.new
    end

    def config
      @config ||= Config.new
    end
  end
end
