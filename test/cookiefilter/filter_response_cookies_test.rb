require 'test_helper'

class Cookiefilter::Test < ActiveSupport::TestCase
  setup do
    @cookielist = {
      keep: [{ key: '_project_session', value: 'test', size: 23 }],
      delete: [{ key: '_cools', value: "1\u{1F36A}", size: 14 }]
    }
    @expires = ' max-age=0; expires=Thu, 01 Jan 1970 00:00:00 -0000;'
    @opts = 'MaxAge=300;Path=/;Domain=.example.com;'
    @header = "_cools=unset;#{@expires}\n"
    @header << "_cools=unset;Domain=.example.com;#{@expires}\n"
    @header << "_cools=unset;Domain=www.example.com;#{@expires}\n"
    @header << "bonks=unset;#{@expires}\n"
    @header << "bonks=unset;Domain=.example.com;#{@expires}\n"
    @header << "bonks=unset;Domain=www.example.com;#{@expires}\n"
    @header << "_project_session=bonkers;#{@opts}"
  end

  test 'filter_response_cookies(response_header, result) works as expected' do
    mock_cookie_filter_safelist([
      { description: 'abc', key: /\Aab.*/, value: /\A1\z/, sacred: false },
      { description: 'session', key: /.*_session\z/, value: nil, sacred: true },
    ])
    resp_header = "bonks=unset;#{@expires}\n_project_session=bonkers;#{@opts}"
    host = 'www.example.com'
    result = Cookiefilter.filter_response_cookies(host, resp_header, @cookielist)
    assert_equal(@header, result)
    revert_cookie_filter_safelist
  end
end
