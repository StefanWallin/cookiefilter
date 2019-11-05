$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'cookiefilter/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'cookiefilter'
  s.version     = Cookiefilter::VERSION
  s.authors     = ['Stefan Wallin']
  s.email       = ['cookiefilter@stefan-wallin.se']

  s.summary     = 'Whitelist your users cookies for your domain.'
  s.description = 'Cookie Filter uses a developer defined safelist of allowed cookies and their values to filter cookies that do not live up to the standard.'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/StefanWallin/cookiefilter'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1'
  s.add_development_dependency 'faker', '~> 2.7.0'
  s.add_development_dependency 'byebug', '~> 11.0.0'
end
