module Slideoff
  autoload :Markdown,        "slideoff/markdown"
  autoload :Presentation,    "slideoff/presentation"
  autoload :SlidesAPI,       "slideoff/slides_api"
  autoload :RemoteAPI,       "slideoff/remote_api"
  autoload :Routes,          "slideoff/routes"
  autoload :Server,          "slideoff/server"
  autoload :ConfigBuilder,   "slideoff/config_builder"
  autoload :Utils,           "slideoff/utils"
  autoload :FlickrImage,     "slideoff/flickr_image"
  autoload :FlickrAPI,       "slideoff/flickr_api"
  autoload :VERSION,         "slideoff/version"

  CONFIG = ConfigBuilder.new(Dir.pwd)
end
