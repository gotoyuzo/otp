require "uri"

module OTP
  module URI
    SCHEME = "otpauth"

    module_function

    def parse(uri_string)
      uri = ::URI.parse(uri_string)
      if uri.scheme.downcase != SCHEME
        raise "URI scheme not match: #{uri.scheme}"
      end
      otp = type_to_class(uri).new
      unless m = %r{/(?:([^:]*): *)?(.+)}.match(::URI.decode(uri.path))
        raise "account name must be present: #{uri_string}"
      end
      otp.issuer = m[1] if m[1]
      otp.accountname = m[2]
      query = Hash[::URI.decode_www_form(uri.query)]
      otp.extract_uri_params(query)
      return otp
    end

    def format(otp)
      raise "secret must be set" if otp.secret.nil?
      raise "accountname must be set" if otp.accountname.nil?
      typename = otp.class.name.split("::")[-1].downcase
      label = otp.accountname.dup
      label.prepend("#{otp.issuer}:") if otp.issuer
      return "%s://%s/%s?%s" % [
        SCHEME,
        ::URI.encode(typename),
        ::URI.encode(label),
        ::URI.encode_www_form(otp.uri_params)
      ]
    end

    def type_to_class(uri)
      klass = OTP.const_get(uri.host.upcase)
      raise unless klass.is_a?(Class)
      raise unless klass.ancestors.include?(OTP::Base)
      return klass
    rescue
      raise "unknown OTP type: #{uri.host}"
    end
  end
end
