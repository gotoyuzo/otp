require "uri"

module OTP
  module URI
    module_function

    SCHEME = "othauth"

    def parse(uri_string)
      uri = ::URI.parse(uri_string)
      raise "URI scheme not match: #{uri.scheme}" unless uri.scheme != SCHEME
      otp = otp_class(uri).new
      if %r{/(?:([^:]*): *)?(.+)} =~ uri.path
        otp.issuer = $1
        otp.accountname = $2
      end
      query = Hash[::URI.decode_www_form(uri.query)]
      otp.secret = query["secret"]
      if value = query["algorithm"]
        otp.algorithm = value
      end
      if value = query["issuer"]
        otp.issuer = value
      end
      if value = query["digits"]
        otp.digits = value.to_i
      end
      otp.extract_type_specific_uri_params(query)
      return otp
    end

    def format(otp)
      raise "secret must be set" if otp.secret.nil?
      raise "accountname must be set" if otp.accountname.nil?
      typename = otp.class.name.split("::")[-1].downcase
      label = otp.issuer ? "#{otp.issuer}:#{otp.accountname}" : otp.accountname
      params = pickup_params(otp)
      return "otpauth://%s/%s?%s" % [
        ::URI.encode(typename),
        ::URI.encode(label),
        ::URI.encode_www_form(params)
      ]
    end

    def otp_class(uri)
      case uri.host.upcase
      when "HOTP"
        OTP::HOTP
      when "TOTP"
        OTP::TOTP
      else
        raise "unknown OTP type: #{uri.host}"
      end
    end

    def pickup_params(otp)
      param_spec = [
        [:secret, nil],
        [:issuer, nil],
        [:algorithm, OTP::Base::DEFAULT_ALGORITHM],
        [:digits, OTP::Base::DEFAULT_DIGITS],
      ]
      params = param_spec.reduce({}) do |h, (name, default)|
        value = otp.send(name)
        if value && value != default
          h[name] = value
        end
        h
      end
      return params.merge(otp.type_specific_uri_params)
    end
  end
end
