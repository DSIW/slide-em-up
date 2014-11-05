require "goliath/server"
require "log4r"

module Slideoff
  class Server
    DEFAULT_PORT = Goliath::Server::DEFAULT_PORT
    DEFAULT_ADDRESS = Goliath::Server::DEFAULT_ADDRESS

    attr_reader :dir, :options, :remote_key, :host, :port

    def initialize(options)
      @dir = Dir.pwd
      @options = options
      @remote_key = @options.delete(:remote_key) || rand(1_000_000).to_s(16)
      @host = @options.delete(:host) || DEFAULT_ADDRESS
      @port = @options.delete(:port) || DEFAULT_PORT
    end

    def start
      server = Goliath::Server.new(host, port)
      server.options = options
      server.app = Slideoff::Routes.run(presentation, :remote_key => remote_key)
      server.logger = logger

      server.start
    end

    def presentation
      Slideoff::Presentation.new(dir)
    end

    private

    def logger
      logger = Log4r::Logger.new(self.class.name)
      logger.add(stdout_outputter)
      logger.level = Log4r::DEBUG
      logger.info("Starting server on http://#{host}:#{port}. Rock your presentation!")
      logger
    end

    def stdout_outputter
      Log4r::StdoutOutputter.new('console', :formatter => log_formatter)
    end

    def log_formatter
      Log4r::PatternFormatter.new(:pattern => "[%p:%l] %d %m")
    end
  end
end
