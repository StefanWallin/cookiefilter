require 'cookiefilter/utils'
require 'cookiefilter/rules'
require 'cookiefilter/errors'
require 'cookiefilter/validator'

class Cookiefilter
  class << self
    def filter_request_cookies(http_cookie)
      # Flag by replacing with cookie emoji(\u{1F36a}) as a token to identify
      # and invalidate cookies later on in is_valid_cookie!
      cookies = Cookiefilter::Utils.sanitize_utf8_string(
        http_cookie,
        Cookiefilter::Rules::DISALLOWED_CHARS,
        Cookiefilter::Rules::INVALID_TOKEN
      )
      cookies = Cookiefilter::Utils.parse_request_cookies(cookies)
      delete, keep = Cookiefilter.validate_request_cookies(cookies)
      header = Cookiefilter::Utils.construct_request_header(keep)
      { delete: delete, keep: keep, header: header.strip }
    end

    def filter_response_cookies(host, response_header, response_cookies)
      keep, delete1 = response_cookies[:keep], response_cookies[:delete]
      cookies = Cookiefilter::Utils.parse_set_cookie_header(response_header)
      set, delete2 = Cookiefilter.validate_response_cookies(cookies)
      cookies = Cookiefilter.merge_keep_and_set(keep, set)
      cookies = Cookiefilter.sort_by_size(cookies)
      keepers, limited = Cookiefilter.maintain_limits(cookies)
      set = Cookiefilter.filter_out_keepers(keepers)
      deleted = Cookiefilter.delete_cookies(delete1 + delete2, limited)
      Cookiefilter::Utils.construct_response_header(host, deleted + set)
    end

    def validate_request_cookies(cookies)
      cookies_to_keep = cookies.select do |cookie|
        is_valid_cookie!(cookie)
      end
      cookies_to_delete = cookies.reject do |cookie|
        is_valid_cookie!(cookie)
      end
      [cookies_to_delete, cookies_to_keep]
    end

    def validate_response_cookies(cookies)
      cookies_to_set, cookies_to_delete = [], []
      cookies.each do |cookie|
        if is_valid_cookie!(cookie)
          cookies_to_set << cookie
        else
          cookies_to_delete << cookie
        end
      end
      [cookies_to_set, cookies_to_delete]
    end

    def delete_cookies(blocked, limited)
      blocked.each do |cookie|
        delete(cookie)
      end
      limited.each do |cookie|
        delete(cookie)
      end
      blocked + limited
    end

    def delete(cookie)
      cookie[:options] = ' max-age=0; expires=Thu, 01 Jan 1970 00:00:00 -0000;'
      cookie[:value] = 'unset'
      cookie
    end

    def merge_keep_and_set(keep, set)
      keep.each do |keeper|
        keeper[:type] = :keep
      end
      set.each do |setter|
        setter[:type] = :set
      end
      return keep + set
    end

    def maintain_limits(sized_cookies, kept_large = [], limited = [])
      if Cookiefilter.cookie_size_too_large?(kept_large, sized_cookies)
        removed = sized_cookies.shift
        if removed[:sacred]
          kept_large.push(removed)
        else
          limited.push(removed)
        end
        return Cookiefilter.maintain_limits(sized_cookies, kept_large, limited)
      else
        return [kept_large + sized_cookies, limited]
      end
    end

    def filter_out_keepers(keepers)
      keepers.select { |keeper| keeper[:type] == :set }
    end

    def sort_by_size(cookies)
      cookies.sort! do |a, b|
        b[:size] <=> a[:size]
      end
    end

    def total_cookie_size(keep, set)
      @size = 0
      keep.each do |cookie|
        @size += cookie[:size]
      end
      set.each do |cookie|
        @size += cookie[:size]
      end
    end

    def cookie_size_too_large?(keep, set)
      Cookiefilter.total_cookie_size(keep, set)
      @size >= Cookiefilter::Rules::COOKIE_DOMAIN_LIMIT
    end

    # This method will regex-check both key and value for
    # this cookie against all safelisted cookies until match
    # is found.
    #   If a valid match is found, true is returned
    #   Otherwise false is returned.

    def is_valid_cookie!(cookie)
      return false if "#{cookie[:key]}=#{cookie[:value]}".bytesize > Cookiefilter::Rules::COOKIE_LIMIT
      return false if /[\u{1F36A}]/.match(cookie[:value])
      Cookiefilter::Rules::safelist.each do |allowed_cookie|
        if allowed_cookie[:key].match(cookie[:key])
          regex = allowed_cookie[:value]

          # Set sacred attribute
          cookie[:sacred] = allowed_cookie[:sacred]

          # Cookies with nil as value-regex, pass validation.
          return true if regex.nil?

          return true if regex.match(cookie[:value])

          # Not matching value regex, fail validation.
          return false
        end
      end
      # Unknown cookie. Log this and fail
      false
    end
  end # end class methods

  def initialize(app)
    Cookiefilter::Validator.validate_safelist(Cookiefilter::Rules.safelist)
    @app = app
    @size = 0
  end

  # entry point, executes directly after initialize
  def call(env)
    result = Cookiefilter.filter_request_cookies(env['HTTP_COOKIE'])
    env['HTTP_COOKIE'] = result[:header]
    status, headers, body = @app.call(env)
    response = Rack::Response.new body, status, headers
    header = Cookiefilter.filter_response_cookies(
      env['HTTP_HOST'],
      response.header['Set-Cookie'],
      result
    )
    response.header['Set-Cookie'] = header
    response.finish
  end
end
