require 'test_helper'

class Cookiefilter::Test < ActiveSupport::TestCase
  test 'filter_request_cookies lets valid cookies headers be pristine' do
    valid_cookie = 'abc=1; abcdefghi=1; _project_session=boolean_masteryexception'
    mock_cookie_filter_safelist([
      { description: 'abc', key: /\Aab.*/, value: /\A1\z/, sacred: false },
      { description: 'session', key: /.*_session\z/, value: nil, sacred: true }
    ])

    result = Cookiefilter.filter_request_cookies(valid_cookie)

    assert_equal(valid_cookie, result[:header])
    assert_equal(
      [
        { key: 'abc', value: '1', sacred: false, size: 7 },
        { key: 'abcdefghi', value: '1', sacred: false, size: 13 },
        { key: '_project_session', value: 'boolean_masteryexception', sacred: true, size: 43 }
      ],
      result[:keep]
    )
    assert_equal([], result[:delete])
    revert_cookie_filter_safelist
  end

  test 'filter_request_cookies hides invalid cookies' do
    invalid_cookie = 'abc=din_mamma; undefined=2'
    mock_cookie_filter_safelist([
      { description: 'abc', key: /\Aab.*/, value: /\A1\z/, sacred: false },
      { description: 'session', key: /.*_session\z/, value: nil, sacred: true }
    ])

    result = Cookiefilter.filter_request_cookies(invalid_cookie)

    assert_equal('', result[:header])
    assert_equal([], result[:keep])
    assert_equal(
      [
        { key: 'abc', value: 'din_mamma', sacred: false, size: 15 },
        { key: 'undefined', value: '2', size: 13 }
      ],
      result[:delete]
    )
    revert_cookie_filter_safelist
  end

  test 'filter_request_cookies hides cookies with invalid encoding' do
    mock_cookie_filter_safelist([
      { description: 'abc', key: /\Aab.*/, value: /\A1\z/, sacred: false },
      { description: 'session', key: /.*_session\z/, value: nil, sacred: true }
    ])
    invalid_utf8 = "_cools=1\255; _project_session=test".force_encoding('UTF-8')
    validated_cookie = '_project_session=test'

    result = Cookiefilter.filter_request_cookies(invalid_utf8)
    assert_equal(validated_cookie, result[:header])
    assert_equal(
      [
        { key: '_project_session', value: 'test', size: 23, sacred: true }
      ],
      result[:keep]
    )
    assert_equal(
      [
        { key: '_cools', value: "1\u{1F36A}", size: 14 }
      ],
      result[:delete]
    )
    revert_cookie_filter_safelist
  end

end
