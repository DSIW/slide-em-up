# encoding: utf-8

module Slideoff
  class FlickrImage
    def initialize(id)
      @id = id
    end

    def image_src
      # Prefer m else lagest size
      size = sizes.select { |size| %w[Large Original].include?(size["label"]) }.first || sizes.last
      size["source"]
    end

    def sizes
      @sizes ||= FlickrAPI.new(method: 'flickr.photos.getSizes', photo_id: @id).json["sizes"]["size"]
    end

    def author
      realname = info["owner"]["realname"]
      !realname.strip.empty? ? realname : info["owner"]["username"]
    end

    def title
      info["title"]["_content"]
    end

    def license
      license_id = info["license"]
      license_id = license_id.to_i rescue 0
      flickr_licenses[license_id]
    end

    def page
      info["urls"]["url"].first["_content"]
    end

    private

    # Source: https://secure.flickr.com/services/api/explore/flickr.photos.licenses.getInfo
    def flickr_licenses
      [
        {
          "name" => "All Rights Reserved",
          "url" => ""
        },
        {
          "name" => "Attribution-NonCommercial-ShareAlike License",
          "url" => "http://creativecommons.org/licenses/by-nc-sa/2.0/",
          "cc_attributes" => %w[by nc sa]
        },
        {
          "name" => "Attribution-NonCommercial License",
          "url" => "http://creativecommons.org/licenses/by-nc/2.0/",
          "cc_attributes" => %w[by nc]
        },
        {
          "name" => "Attribution-NonCommercial-NoDerivs License",
          "url" => "http://creativecommons.org/licenses/by-nc-nd/2.0/",
          "cc_attributes" => %w[by nc nd]
        },
        {
          "name" => "Attribution License",
          "url" => "http://creativecommons.org/licenses/by/2.0/",
          "cc_attributes" => %w[by]
        },
        {
          "name" => "Attribution-ShareAlike License",
          "url" => "http://creativecommons.org/licenses/by-sa/2.0/",
          "cc_attributes" => %w[by sa]
        },
        {
          "name" => "Attribution-NoDerivs License",
          "url" => "http://creativecommons.org/licenses/by-nd/2.0/",
          "cc_attributes" => %w[by nd]
        },
        {
          "name" => "No known copyright restrictions",
          "url" => "http://www.flickr.com/commons/usage/"
        },
        {
          "name" => "United States Government Work",
          "url" => "http://www.usa.gov/copyright.shtml"
        }
      ]
    end

    def info
      @info ||= FlickrAPI.new(method: 'flickr.photos.getInfo', photo_id: @id).json["photo"]
    end
  end
end
