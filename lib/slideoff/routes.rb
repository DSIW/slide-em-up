require "rack/builder"


module Slideoff
  class Routes

    def self.run(presentation, opts = {})
      Rack::Builder.new do
        map '/remote' do
          run Slideoff::RemoteAPI.new(opts[:remote_key])
        end

        map '/' do
          run Slideoff::SlidesAPI.new(presentation)
        end
      end
    end

  end
end
