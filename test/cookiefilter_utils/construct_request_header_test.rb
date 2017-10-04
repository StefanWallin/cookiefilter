require 'test_helper'

class Cookiefilter::Utils::Test < ActiveSupport::TestCase
  test 'construct_request_header generates correctly formatted HTTP_COOKIE request header' do
    before = [
      { key: '_project_session', value: 'true' },
      { key: 'abcdefghi', value: 'true' }
    ]
    after = '_project_session=true; abcdefghi=true'
    result = Cookiefilter::Utils.construct_request_header(before)
    assert_equal(after, result)
  end
end
