# encoding: utf-8

require 'net/http'
require 'json'

module Slideoff
  class FlickrAPIException < Exception
    def initialize(code, message)
      @code = code
      @message = message
    end

    def self.from_json(json)
      new(json['code'], json['message'])
    end

    def to_s
      "#{@message} [Code: #{@code}]"
    end
  end
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
      @json ||= begin
        _json = JSON.parse(Net::HTTP.get(uri))
        raise FlickrAPIException.from_json(_json) unless _json['stat'] == 'ok'
        _json
      end
    end
  end
end
