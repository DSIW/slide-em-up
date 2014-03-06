# encoding: utf-8

require "yajl"
require "ostruct"

module Slideoff
  class ConfigBuilder < OpenStruct
    DEFAULT = {
      "title" => "No title",
      "theme" => "shower",
      "duration" => 60,
      "author" => "Max Mustermann",
      "pygments_style" => "colorful"
    }
    SECTION_DEFAULT = {
      "show_chapter" => true,
      "show_toc" => true
    }

    def initialize(_dir)
      infos = extract_normal_infos(_dir) || extract_infos_from_showoff(_dir) || {}

      unless infos.empty?
        infos = DEFAULT.merge({dir: _dir}.merge(infos))
        infos['sections'] = infos['sections'].reduce({}) do |new_hash, (k, hash)|
          new_hash.merge!(k => SECTION_DEFAULT.merge(hash))
        end
        Dir.chdir(_dir) do
          infos['css'] = Dir["**/*.css"]
          infos['js']  = Dir["**/*.js"]
        end
        ENV["FLICKR_API_KEY"] = infos['flickr_api_key']
      end

      super(infos)
    end

    private

    def extract_normal_infos(dir)
      parse_file(dir, "presentation")
    end

    def extract_infos_from_showoff(dir)
      infos = parse_file(dir, "showoff")
      sections = infos["sections"].map {|s| s["section"] }
      {
        "title" => infos["name"],
        "theme" => "showoff",
        "sections" => sections
      }
    end

    def parse_file(dir, file)
      filename = "#{dir}/#{file}.json"
      return {} unless File.exists?(filename)
      Yajl::Parser.parse(File.read filename)
    end
  end
end
