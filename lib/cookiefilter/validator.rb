class Cookiefilter::Validator
  class << self
    def validate_safelist
      safelist = Cookiefilter::Rules.safelist
      err = Cookiefilter::MalformedSafelistError

      Cookiefilter::Validator.validate_array(err, safelist)
      safelist.each_index do |index|
        obj = safelist[index]
        Cookiefilter::Validator.validate_hash(err, index, obj)
        Cookiefilter::Validator.validate_keys(err, index, obj)
        Cookiefilter::Validator.validate_description(err, index, obj)
        Cookiefilter::Validator.validate_key(err, index, obj)
        Cookiefilter::Validator.validate_value(err, index, obj)
        Cookiefilter::Validator.validate_sacred(err, index, obj)
      end
    end

    def validate_array(err, list)
      raise err, 'safelist method does not return Array' if list.class != Array
    end

    def validate_hash(err, index, obj)
      if obj.class != Hash
        raise err, "safelist child with index #{index}: Is not an Hash Object"
      end
    end

    def validate_keys(err, index, obj)
      %w(description key value sacred).each do |key|
        unless obj.has_key?(key.to_sym)
          raise err, "safelist child with index #{index}: Missing key :#{key}"
        end
      end
    end

    def validate_description(err, index, obj)
      description = obj[:description]
      if description.class != String
        return raise err, "safelist child with index #{index}: ':description' \
          must be of class String, got #{description.class}"
      end
    end

    def validate_key(err, index, obj)
      key = obj[:key]
      if key.class != Regexp
        return raise err, "safelist child with index #{index}: ':key' \
          must be of class Regexp, got #{key.class}"
      end
    end

    def validate_value(err, index, obj)
      value = obj[:value]
      if value.class != Regexp && value.class != NilClass
        return raise err, "safelist child with index #{index}: ':value' \
          must be of class Regexp or NilClass, got #{value.class}"
      end
    end

    def validate_sacred(err, index, obj)
      sacred = obj[:sacred]
      if obj[:sacred].class != TrueClass && obj[:sacred].class != FalseClass
        return raise err, "safelist child with index #{index}: ':sacred' \
          must be of class TrueClass or FalseClass, got #{sacred.class}"
      end
    end
  end
end
