# encoding: utf-8

require 'net/http'
require 'json'

module SlideEmUp
  class FlickrAPI
    ENDPOINT = "http://api.flickr.com/services/rest/"

    DEFAULT_PARAMS = {
      :api_key => ENV["FLICKR_API_KEY"],
      :format => :json,
      :nojsoncallback => 1
    }

    def initialize(params = {})
      raise "Please specify your Flickr API key in presentation.json" unless ENV["FLICKR_API_KEY"]
      @params = params
    end

    def uri
      _uri = URI(ENDPOINT)
      _uri.query = URI.encode_www_form(DEFAULT_PARAMS.merge(@params))
      _uri
    end

    def json
      @json ||= JSON.parse(Net::HTTP.get(uri))
    end
  end
end
