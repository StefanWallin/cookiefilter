require 'test_helper'

class Cookiefilter::Utils::Test < ActiveSupport::TestCase
  test 'parses correct strings successfully' do
    cookie_str = 'abcdefghi=true; _project_session=boolean_masteryexception;'
    expected_return = [
      { key: 'abcdefghi', value: 'true', size: 16 },
      { key: '_project_session', value: 'boolean_masteryexception', size: 43 }
    ]
    result = Cookiefilter::Utils.parse_request_cookies(cookie_str)
    assert_equal(expected_return, result)
  end
end
