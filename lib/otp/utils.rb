require "openssl"

module OTP
  module Utils
    private

    def pack_int64(i)
      return [i >> 32 & 0xffffffff, i & 0xffffffff].pack("NN")
    end

    def hmac(algorithm, secret, text)
      mac = OpenSSL::HMAC.new(secret, algorithm)
      mac << text
      return mac.digest
    end

    def truncate(hash)
      offset = hash[-1].ord & 0xf
      binary = hash[offset, 4]
      return binary.unpack("N")[0] & 0x7fffffff
    end

    def compare(a, b)
      return a.to_i == b.to_i
    end
  end
end
