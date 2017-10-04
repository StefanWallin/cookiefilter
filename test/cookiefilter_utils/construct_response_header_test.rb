require 'test_helper'

class Cookiefilter::Utils::Test < ActiveSupport::TestCase
  test 'construct_response_header keeps options intact and generate valid headers' do
    expires = ' max-age=0; expires=Thu, 01 Jan 1970 00:00:00 -0000;'
    opts = 'MaxAge=300;Path=/;Domain=.example.com;'
    cookies = [
      { key: 'abcdefghi', value: 'unset', options: expires },
      { key: '_project_session', value: 'bonkers', options: opts }
    ]
    header = "abcdefghi=unset;#{expires}\n"
    header << "abcdefghi=unset;Domain=.example.org;#{expires}\n"
    header << "abcdefghi=unset;Domain=www.example.org;#{expires}\n"
    header << "_project_session=bonkers;#{opts}"

    result = Cookiefilter::Utils.construct_response_header('www.example.org', cookies)
    assert_equal(header, result)
  end
end
