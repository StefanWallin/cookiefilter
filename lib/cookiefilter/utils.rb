require 'cookiefilter/errors'

class Cookiefilter::Utils
  class << self
    def sanitize_utf8_string(cookie_string, banned_chars, replace_char)
      result = ''
      # blank? can'd handle broken utf-8 characters.
      return result if cookie_string.nil?
      cookie_string.each_char do |char|
        if banned_chars.include? char
          result << replace_char
        else
          result << char
        end
      end
      result
    end

    def parse_request_cookies(cookie_string)
      cookies = []
      return cookies if cookie_string.blank?
      cookie_strings = cookie_string.split(';')
      cookie_strings.each do |cookie|
        key, value = cookie.strip.split('=', 2)
        cookies << { key: key, value: value, size: "#{key}=#{value}; ".bytesize }
      end
      cookies
    end

    def parse_set_cookie_header(header)
      cookies = []
      return cookies if header.blank?
      header_cookies = header.split("\n")
      header_cookies.each do |cookie|
        key, rest = cookie.strip.split('=', 2)
        value, options = rest.strip.split(';', 2)
        options = '' if options.nil?
        size = "#{key}=#{value}; ".bytesize
        cookies << { key: key, value: value, options: options, size: size }
      end
      cookies
    end

    def construct_request_header(cookies_to_keep)
      http_cookie = ''
      cookies_to_keep.each do |cookie|
        http_cookie << "#{cookie[:key]}=#{cookie[:value]}; "
      end
      #  Chopping last ';' since headers does not expect it.
      http_cookie.strip.chomp(';')
    end

    def construct_response_header(host, set)
      http_cookies = []
      naked_host = host.sub!(/\Awww\./, '')
      set.each do |cookie|
        http_cookies << "#{cookie[:key]}=#{cookie[:value]};#{cookie[:options]}"
        if cookie[:value] == 'unset'
          http_cookies << "#{cookie[:key]}=#{cookie[:value]};Domain=.#{naked_host};#{cookie[:options]}"
          http_cookies << "#{cookie[:key]}=#{cookie[:value]};Domain=www.#{naked_host};#{cookie[:options]}"
        end
      end
      http_cookies.join("\n")
    end
  end
end
