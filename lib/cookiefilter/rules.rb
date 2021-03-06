class Cookiefilter::Rules
  COOKIE_DOMAIN_LIMIT = 8186
  COOKIE_LIMIT = 4093
  DISALLOWED_CHARS = [
    "\192", "\193", "\245", "\246", "\247", "\248", "\249",
    "\250", "\251", "\252", "\253", "\254", "\255"
  ]
  INVALID_TOKEN = "\u{1F36A}"


  def self.method_missing(m, *args, &block)
    if m.to_sym == :safelist
      raise Cookiefilter::SafelistMissingError
    else
      raise ArgumentError.new("Method `#{m}` doesn't exist.")
    end
  end

  def self.respond_to?(method_name, include_private = false)
    method_name.to_sym == :safelist || super
  end
end
