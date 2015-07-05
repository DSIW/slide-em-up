# encoding: utf-8

require "yajl"
require "ostruct"

module Slideoff
  class ConfigBuilder < OpenStruct
    DEFAULT = {
      "dir" => "#{ENV['HOME']}/.config/slideoff",
      "title" => "No title",
      "theme" => "shower",
      "duration" => 60,
      "author" => "Max Mustermann",
      "pygments_style" => "colorful",
      "static_dir" => "static"
    }
    SECTION_DEFAULT = {
      "show_chapter" => true,
      "show_toc" => true
    }

    def initialize(_dir)
      config = DEFAULT.merge({pwd: _dir})

      infos = extract_presentation_infos(_dir) || extract_showoff_presentation_infos(_dir) || {}
      unless infos.empty?
        infos['sections'] = infos['sections'].reduce({}) do |new_hash, (k, hash)|
          new_hash.merge!(k => SECTION_DEFAULT.merge(hash))
        end
        Dir.chdir(_dir) do
          infos['css'] = Dir["**/*.css"].sort - Dir["#{DEFAULT["static_dir"]}/**/*.css"]
          infos['js']  = Dir["**/*.js"].sort - Dir["#{DEFAULT["static_dir"]}/**/*.js"]
        end
        ENV["FLICKR_API_KEY"] = infos['flickr_api_key']
      end

      super(config.merge(infos))
    end

    private

    def extract_presentation_infos(dir)
      parse_json_file(dir, "presentation")
    end

    # backward compability for showoff
    def extract_showoff_presentation_infos(dir)
      infos = parse_json_file(dir, "showoff")
      sections = infos["sections"].map {|s| s["section"] }
      {
        "title" => infos["name"],
        "theme" => "showoff",
        "sections" => sections
      }
    end

    def parse_json_file(dir, file)
      filename = "#{dir}/#{file}.json"
      return {} unless File.exists?(filename)
      Yajl::Parser.parse(File.read filename)
    end
  end
end
