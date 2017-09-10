class Cookiefilter::SafelistMissingError < StandardError
  def message
    'Please define your cookie safelist as documented in Readme and then\
     restart your rails server.'
  end
  def backtrace
    []
  end
end

class Cookiefilter::MalformedSafelistError < StandardError
  def backtrace
    []
  end
end
