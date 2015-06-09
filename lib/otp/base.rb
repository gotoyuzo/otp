require "otp/utils"
require "otp/base32"
require "otp/uri"

module OTP
  class Base
    include OTP::Utils

    DEFAULT_DIGITS = 6
    DEFAULT_ALGORITHM = "SHA1"

    attr_accessor :secret
    attr_accessor :algorithm
    attr_accessor :digits
    attr_accessor :issuer, :accountname

    def initialize(secret=nil, algorithm=nil, digits=nil)
      self.secret = secret
      self.algorithm = algorithm || DEFAULT_ALGORITHM
      self.digits = digits || DEFAULT_DIGITS
    end

    def new_secret(num_bytes=10)
      self.raw_secret = OpenSSL::Random.random_bytes(num_bytes)
    end

    def raw_secret=(bytes)
      self.secret = OTP::Base32.encode(bytes)
    end

    def raw_secret
      return OTP::Base32.decode(secret)
    end

    def moving_factor
      raise NotImplementedError
    end

    def otp(generation=0)
      message = pack_int64(moving_factor+generation)
      hash = hmac(algorithm, raw_secret, message)
      return truncate(hash)
    end

    def password(generation=0)
      pw = (otp(generation) % (10 ** digits)).to_s
      pw = "0" + pw while pw.length < digits
      return pw
    end

    def verify(given_pw, last:0, post:0)
      raise ArgumentError, "last must be greater than or equal to 0" if last < 0
      raise ArgumentError, "post must be greater than or equal to 0" if post < 0
      return false if given_pw.nil? || given_pw.empty?
      return (-last..post).any?{|i| compare(password(i), given_pw) }
    end

    def to_uri
      return OTP::URI.format(self)
    end

    def type_specific_uri_params
      raise NotImplementedError
    end

    def extract_type_specific_uri_params(_query)
      raise NotImplementedError
    end
  end
end
