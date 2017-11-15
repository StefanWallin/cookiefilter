 [![Build Status](https://travis-ci.org/StefanWallin/cookiefilter.svg?branch=master)](https://travis-ci.org/StefanWallin/cookiefilter)
 [![Gem Version](https://badge.fury.io/rb/cookiefilter.svg)](https://badge.fury.io/rb/cookiefilter)
# Cookiefilter
Cookie Filter uses a developer defined safelist of allowed cookies and their
values to filter cookies that are not allowed by the safelist configuration.
This gem filters both incoming cookies from the browser and what cookies can
be set from rails. I want to thank MittMedia DMU for allowing me to open source
this piece of code. We are always looking for new developers ;).

## When would I use this?
- If you want to be on top of what data is allowed to be passed to your server.
- If you have third party code executing on your first party domain(ads) that set
  arbitrary cookies.
- If your amount and size of cookies can run out of control and exceed the http
  header limit of 8186 bytes. (At which time certain cloud providers simply
  interpret that request as an attack and serves back a white page)
- If you're already running mod_security or similar web firewalls and need to
  complement with cookie filtering.

## Performance
Measurment has shown that this filter adds less than 1ms per request.

This library has been in production on sites with 5 million weekly pageviews
for 2 years before being packaged as a gem and open sourced.

*This gem package has not been tested in production.*

## Getting started
Install the [cookiefilter](http://rubygems.org/StefanWallin/cookiefilter) gem;
or add it to your Gemfile with bundler:

Add this line to your application's `Gemfile`:
```ruby
gem 'cookiefilter'
```

And then execute:
```bash
$ bundle install
```

Tell your app to use the Cookiefilter middleware.
For Rails 4+ apps:

```ruby
# In config/application.rb
config.middleware.use Cookiefilter
```

Add a `cookiefilter.rb` file to `config/initializers/`:
```ruby
# In config/initializers/cookiefilter.rb
class Cookiefilter
  def self.safelist
    # This is an array of hashes. It serves as a living documentation of our
    # allowed cookies and their format. Need help with regex? Visit this site:
    # http://rubular.com/

    # Each hash in the array is per cookie with the following format:
    #   description: Human readable string of what/who this cookie pertains.
    #   key: A regex that matches the name of the cookie or cookies matching
    #        the above description.
    #   value: A regex that validates the content of the cookie, if the regex
    #          is nil, no validation is done.
    #   sacred: This is a boolean indicating that this cookie are not to be
    #           removed to decrease the overall size of cookies per domain.
    #           It will however be removed in second run if no other options
    #           are left.
    [
      {
        description: 'Rails Session Cookie',
        key: /\Aproject_name_session\z/,
        value: nil,
        sacred: true
      }
    ]
  end
end
```

**Then restart your rails server.**

Happy filtering!

## License
The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

## Contribute
All contributions are welcome, issues and PR's.
Make sure tests pass by running them like so:
```ruby
rake test
```
