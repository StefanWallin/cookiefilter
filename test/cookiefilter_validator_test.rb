require 'test_helper'

class Cookiefilter::Validator::Test < ActiveSupport::TestCase
  setup do
    @obj = {
      description: '',
      key: //,
      value: nil,
      sacred: false
    }
  end

  # OUTER ARRAY
  test 'Validates outer array without raising' do
    assert_nothing_raised do
      assert_equal(true, Cookiefilter::Validator.validate_safelist([]))
    end
  end

  test 'Validates outer object raises' do
    assert_raise Cookiefilter::MalformedSafelistError do
      Cookiefilter::Validator.validate_safelist({})
    end
  end

  # OUTER OBJECT
  test 'Validates inner object without raising' do
    assert_nothing_raised do
      assert_equal(true, Cookiefilter::Validator.validate_safelist([@obj]))
    end
  end

  # INNER OBJECT KEYS
  test 'Validates inner object has description' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj.delete(:description)
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates inner object has key' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj.delete(:key)
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates inner object has value' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj.delete(:value)
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates inner object has sacred' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj.delete(:sacred)
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  # OBJECT PROPERTIES - Integer
  test 'Validates description cannot be integer' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:description] = 1
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates key cannot be integer' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:key] = 1
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates value cannot be integer' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:value] = 1
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates sacred cannot be integer' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:sacred] = 1
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  # OBJECT PROPERTIES - String
  test 'Validates description can be String' do
    assert_nothing_raised do
      @obj[:description] = '1'
      assert_equal(true, Cookiefilter::Validator.validate_safelist([@obj]))
    end
  end

  test 'Validates key cannot be String' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:key] = '1'
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates value cannot be String' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:value] = '1'
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates sacred cannot be String' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:sacred] = '1'
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  # OBJECT PROPERTIES - NilClass
  test 'Validates description cannot be NilClass' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:description] = nil
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates key cannot be NilClass' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:key] = nil
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates value can be NilClass' do
    assert_nothing_raised do
      @obj[:value] = nil
      assert_equal(true, Cookiefilter::Validator.validate_safelist([@obj]))
    end
  end

  test 'Validates sacred cannot be NilClass' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:sacred] = nil
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  # OBJECT PROPERTIES - TrueClass
  test 'Validates description cannot be TrueClass' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:description] = true
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates key cannot be TrueClass' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:key] = true
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates value cannot be TrueClass' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:value] = true
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates sacred can  be TrueClass' do
    assert_nothing_raised do
      @obj[:sacred] = true
      assert_equal(true, Cookiefilter::Validator.validate_safelist([@obj]))
    end
  end

  # OBJECT PROPERTIES - FalseClass
  test 'Validates description cannot be FalseClass' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:description] = false
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates key cannot be FalseClass' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:key] = false
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates value cannot be FalseClass' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:value] = false
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates sacred can be FalseClass' do
    assert_nothing_raised do
      @obj[:sacred] = false
      assert_equal(true, Cookiefilter::Validator.validate_safelist([@obj]))
    end
  end

  # OBJECT PROPERTIES - Object
  test 'Validates description cannot be Object' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:description] = {}
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates key cannot be Object' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:key] = {}
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates value cannot be Object' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:value] = {}
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates sacred cannot be Object' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:sacred] = {}
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  # OBJECT PROPERTIES - Regexp
  test 'Validates description cannot be Regexp' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:description] = //
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end

  test 'Validates key can be Regexp' do
    assert_nothing_raised do
      @obj[:key] = //
      assert_equal(true, Cookiefilter::Validator.validate_safelist([@obj]))
    end
  end

  test 'Validates value can be Regexp' do
    assert_nothing_raised do
      @obj[:value] = //
      assert_equal(true, Cookiefilter::Validator.validate_safelist([@obj]))
    end
  end

  test 'Validates sacred cannot be Regexp' do
    assert_raise Cookiefilter::MalformedSafelistError do
      @obj[:sacred] = //
      Cookiefilter::Validator.validate_safelist([@obj])
    end
  end
end
