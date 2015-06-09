require "openssl"

module OTP
  module Utils
    private

    def otp(algorithm, secret, moving_factor, digits)
      message = pack_int64(moving_factor)
      digest = hmac(algorithm, secret, message)
      num = pickup(digest)
      return truncate(num, digits)
    end

    def pack_int64(i)
      return [i >> 32 & 0xffffffff, i & 0xffffffff].pack("NN")
    end

    def hmac(algorithm, secret, text)
      mac = OpenSSL::HMAC.new(secret, algorithm)
      mac << text
      return mac.digest
    end

    def pickup(digest)
      offset = digest[-1].ord & 0xf
      binary = digest[offset, 4]
      return binary.unpack("N")[0] & 0x7fffffff
    end

    def truncate(num, digits)
      pw = (num % (10 ** digits)).to_s
      pw.prepend("0") while pw.length < digits
      return pw
    end

    def compare(a, b)
      return a.to_i == b.to_i
    end
  end
end
