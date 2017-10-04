def revert_cookie_filter_safelist
  silence_warnings do
    class <<Cookiefilter::Rules
      alias_method :safelist, :orig_safelist
      remove_method :orig_safelist
    end
  end
end

def remove_cookie_filter_safelist
  silence_warnings do
    class <<Cookiefilter::Rules
      alias_method :orig_safelist, :safelist
      remove_method :safelist
    end
  end
end

def mock_cookie_filter_safelist(safelist_rules)
  $rules = safelist_rules
  silence_warnings do
    class <<Cookiefilter::Rules
      alias_method :orig_safelist, :safelist
      define_method(:safelist) { return $rules.clone }
    end
  end
end

def request_through_safelist(request_cookies)
  mock_cookie_filter_safelist([
    { description: 'abc', key: /\Aab.*/, value: /\A1\z/, sacred: false },
    { description: 'session', key: /.*_session\z/, value: nil, sacred: true },
    { description: 'large', key: /\Alarge.*\z/, value: nil, sacred: true },
  ])
  app = proc { [200, {}, ['Hello, world.']] }
  cookiefilter = Cookiefilter.new(app)
  request = Rack::MockRequest.new(cookiefilter)
  result = {}
  _, headers, = request.get('/',
                            'HTTP_COOKIE' => request_cookies,
                            'HTTP_HOST' => 'www.example.org')
  cookies = headers['Set-Cookie']
  return result if cookies.nil?
  cookies = cookies.split("\n")
  cookies.each do |cookie|
    name, rest = cookie.split('=', 2)
    expires = (rest.index('unset') == 0)
    result[name.to_sym] = expires
  end
  revert_cookie_filter_safelist
  result
end

class MockResponse
  attr_reader :header
  def initialize(header = {})
    @header = header
  end
end
