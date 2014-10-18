require "./lib/slideoff.rb"

Gem::Specification.new do |s|
  s.name             = "slideoff"
  s.version          = Slideoff::VERSION
  s.date             = Time.now.utc.strftime("%Y-%m-%d")
  s.homepage         = "http://github.com/DSIW/slideoff"
  s.authors          = "DSIW"
  s.email            = "dsiw@dsiw-it.de"
  s.description      = "Slideoff is a presentation tool that displays markdown-formatted slides"
  s.summary          = "Slideoff is a presentation tool. You write some slides in markdown, choose a style and it displays it in HTML5. With a browser in full-screen, you can make amazing presentations!"
  s.license          = 'MIT'
  s.extra_rdoc_files = %w(README.md)
  s.files            = Dir["MIT-LICENSE", "README.md", "Gemfile", "bin/*", "lib/**/*.rb", "themes/**/*"]
  s.executables      = ["slideoff"]
  s.require_paths    = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.add_dependency "goliath", "=1.0.2"
  s.add_dependency "redcarpet", "~>2.1"
  s.add_dependency "erubis", "~>2.7"
  s.add_dependency "yajl-ruby", "~>1.1"
  s.add_dependency "pygments.rb", "~>0.3"
  s.add_dependency "gli", "~>2.9"
end
