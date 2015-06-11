require "openssl"

module OTP
  module Utils
    private

    def otp(algorithm, secret, moving_factor, digits)
      message = otp_pack_int64(moving_factor)
      digest = otp_hmac(algorithm, secret, message)
      num = otp_pickup(digest)
      return otp_truncate(num, digits)
    end

    def otp_pack_int64(i)
      return [i >> 32 & 0xffffffff, i & 0xffffffff].pack("NN")
    end

    def otp_hmac(algorithm, secret, text)
      mac = OpenSSL::HMAC.new(secret, algorithm)
      mac << text
      return mac.digest
    end

    def otp_pickup(digest)
      offset = digest[-1].ord & 0xf
      binary = digest[offset, 4]
      return binary.unpack("N")[0] & 0x7fffffff
    end

    def otp_truncate(num, digits)
      pw = (num % (10 ** digits)).to_s
      pw.prepend("0") while pw.length < digits
      return pw
    end

    def otp_compare(a, b)
      return a.to_i == b.to_i
    end
  end
end
