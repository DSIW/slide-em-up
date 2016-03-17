module Slideoff
  autoload :Markdown,        "slideoff/markdown"
  autoload :Presentation,    "slideoff/presentation"
  autoload :SlidesAPI,       "slideoff/slides_api"
  autoload :RemoteAPI,       "slideoff/remote_api"
  autoload :Routes,          "slideoff/routes"
  autoload :Server,          "slideoff/server"
  autoload :ConfigBuilder,   File.expand_path("slideoff/config_builder", File.dirname(__FILE__))
  autoload :Utils,           "slideoff/utils"
  autoload :FlickrImage,     "slideoff/flickr_image"
  autoload :FlickrAPI,       "slideoff/flickr_api"

  CONFIG = ConfigBuilder.new(Dir.pwd)
  VERSION = "0.4.0"
end
