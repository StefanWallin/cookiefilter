class Cookiefilter::Rules
  COOKIE_DOMAIN_LIMIT = 8186
  COOKIE_LIMIT = 4093
  DISALLOWED_CHARS = [
    "\192", "\193", "\245", "\246", "\247", "\248", "\249",
    "\250", "\251", "\252", "\253", "\254", "\255"
  ]
  INVALID_TOKEN = "\u{1F36A}"

  def self.safelist
    raise Cookiefilter::SafelistMissingError
  end
end
