require 'test_helper'

class Cookiefilter::Test < ActiveSupport::TestCase
  test 'has a version number' do
    assert_not_nil Cookiefilter::VERSION
  end
end

class Cookiefilter::Rules::Test < ActiveSupport::TestCase
  test 'Throws error for undefined safelist' do
    remove_cookie_filter_safelist
    assert_raise Cookiefilter::SafelistMissingError do
      Cookiefilter::Rules.safelist
    end
    revert_cookie_filter_safelist
  end

  test 'Does not throw error for defined safelist' do
    assert_equal([], Cookiefilter::Rules.safelist)
  end
end
