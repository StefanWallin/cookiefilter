require 'test_helper'
require 'faker'

class Cookiefilter::Test < ActiveSupport::TestCase
  test 'persists cookies with allowed names' do
    valid_cookie = '_project_session=boolean_masteryexception'
    expiring_cookies = request_through_safelist(valid_cookie)
    assert_equal(false, expiring_cookies.key?(:_project_session))
  end

  test 'persists cookies with allowed values' do
    valid_cookie = 'abc=1'
    expiring_cookies = request_through_safelist(valid_cookie)
    assert_equal(false, expiring_cookies.key?(:abc))
  end

  test 'expires cookies with forbidden names' do
    invalid_cookie = 'undefined=2'
    expiring_cookies = request_through_safelist(invalid_cookie)
    assert_equal(true, expiring_cookies.key?(:undefined))
  end

  test 'expires cookies with forbidden values' do
    invalid_cookie = 'abc=din_mamma'
    expiring_cookies = request_through_safelist(invalid_cookie)
    assert_equal(true, expiring_cookies.key?(:abc))
  end

  test 'expires cookies that are too long' do
    # generate a cookie that is COOKIE_LIMIT (including name)
    fake = Faker::Lorem.characters(Cookiefilter::Rules::COOKIE_LIMIT - 5)
    large_cookie = "abc=1; undefined=2; large=#{fake}"

    expiring_cookies = request_through_safelist(large_cookie)
    assert_equal(true, expiring_cookies.key?(:large))
    assert_equal(false, expiring_cookies.key?(:abc))
  end

  test 'expires cookies selectively when cookie header is too long' do
    # generate cookieheader above COOKIE_DOMAIN_LIMIT with all
    # individual cookies below the COOKIE_LIMIT threshold.
    fake1 = Faker::Lorem.characters(Cookiefilter::Rules::COOKIE_LIMIT - 8)
    fake2 = Faker::Lorem.characters(Cookiefilter::Rules::COOKIE_LIMIT - 9)
    large_cookie_header = "abc=1; _project_session=#{fake1}; large1=#{fake1}; large2=#{fake2}"
    if large_cookie_header.bytesize < Cookiefilter::Rules::COOKIE_DOMAIN_LIMIT
      raise 'invalid_test_data: large_cookie_header is too small'
    end
    expiring_cookies = request_through_safelist(large_cookie_header)
    assert_equal(true, expiring_cookies.key?(:large1))
  end

  test 'expires cookies that have invalid bytesequences' do
    invalid_utf8 = "_cool=1\255; _project_session=test".force_encoding('UTF-8')
    expiring_cookies = request_through_safelist(invalid_utf8)
    assert_equal(false, expiring_cookies.key?(:_project_session))
    assert_equal(true, expiring_cookies.key?(:_cool))
  end
end
