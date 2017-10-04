require 'test_helper'

class Cookiefilter::Utils::Test < ActiveSupport::TestCase
  test 'parse_set_cookie_header parses set cookie header correctly' do
    before = "_project_session=true;\nabcdefghi=true"
    after = [
      { key: '_project_session', value: 'true', options: '', size: 23 },
      { key: 'abcdefghi', value: 'true', options: '', size: 16 },
    ]
    result = Cookiefilter::Utils.parse_set_cookie_header(before)
    assert_equal(after, result)
  end
end
