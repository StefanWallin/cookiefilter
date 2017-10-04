require 'test_helper'

class Cookiefilter::Utils::Test < ActiveSupport::TestCase
  setup do
    @banned_chars = Cookiefilter::Rules::DISALLOWED_CHARS
    @char = Cookiefilter::Rules::INVALID_TOKEN
    @invalid_utf8 = "abcdef=1\255; _project_session=test".force_encoding('UTF-8')
    @valid_utf8 = "abcdef=1\u{1F36A}; _project_session=test".force_encoding('UTF-8')
  end

  test 'sanitize_utf8_string modifies invalid utf8 character strings' do
    result = Cookiefilter::Utils.sanitize_utf8_string(
      @invalid_utf8,
      @banned_chars,
      @char
    )
    assert_not_equal(@invalid_utf8, result)
  end

  test 'sanitize_utf8_string let valid strings be unchanged' do
    result = Cookiefilter::Utils.sanitize_utf8_string(
      @valid_utf8,
      @banned_chars,
      @char
    )
    assert_equal(@valid_utf8, result)
  end

  test 'sanitize_utf8_string changes invalid strings into valid strings' do
    result = Cookiefilter::Utils.sanitize_utf8_string(
      @invalid_utf8,
      @banned_chars,
      @char
    )
    assert_equal(@valid_utf8, result)
  end

  test 'sanitize_utf8_string inserts cookie emoji as token into sanitized string' do
    result = Cookiefilter::Utils.sanitize_utf8_string(
      @invalid_utf8,
      @banned_chars,
      @char
    )
    assert_equal(true, result.include?("\u{1F36A}"))
  end
end
