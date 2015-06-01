require "otp/utils"
require "otp/base32"

module OTP
  class Base
    include OTP::Utils

    attr_accessor :secret
    attr_accessor :algorithm
    attr_accessor :digits

    def initialize(secret=nil, algorithm="SHA1", digits=6)
      self.secret = secret
      self.algorithm = algorithm
      self.digits = digits
    end

    def new_secret(num_bytes=10)
      s = (0...num_bytes).map{ Random.rand(256).chr }.join
      self.secret = OTP::Base32.encode(s)
    end

    def moving_factor
      raise NotImplementedError
    end

    def otp
      hash = hmac(algorithm, OTP::Base32.decode(secret),
                  pack_int64(moving_factor))
      return truncate(hash)
    end

    def password
      pw = (otp % (10 ** digits)).to_s
      pw = "0" + pw while pw.length < digits
      return pw
    end

    def verify(otp)
      return false if otp.nil? || otp.empty?
      return compare(password, otp)
    end
  end
end
