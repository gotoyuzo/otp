require "otp/utils"
require "otp/base32"
require "otp/uri"

module OTP
  class Base
    include OTP::Utils

    DEFAULT_DIGITS = 6
    DEFAULT_ALGORITHM = "SHA1"

    attr_accessor :secret, :algorithm, :digits
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

    def password(generation=0)
      return otp(algorithm, raw_secret, moving_factor+generation, digits)
    end

    def verify(given_pw, last:0, post:0)
      raise ArgumentError, "last must be greater than or equal to 0" if last < 0
      raise ArgumentError, "post must be greater than or equal to 0" if post < 0
      return false if given_pw.nil? || given_pw.empty?
      return (-last..post).any?{|i| otp_compare(password(i), given_pw) }
    end

    def to_uri
      return OTP::URI.format(self)
    end

    def uri_params
      params = {}
      params[:secret] = secret
      params[:issuer] = issuer if issuer
      params[:algorithm] = algorithm if algorithm != DEFAULT_ALGORITHM
      params[:digits] = digits if digits != DEFAULT_DIGITS
      return params
    end

    def extract_uri_params(params)
      self.secret = params["secret"]
      self.issuer = issuer || params["issuer"]
      self.algorithm = params["algorithm"] || algorithm
      self.digits = (params["digits"] || digits).to_i
    end
  end
end
