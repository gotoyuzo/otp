require "otp/base"

module OTP
  class HOTP < OTP::Base
    attr_accessor :count

    def initialize(*args)
      super
      self.count = 0
    end

    def moving_factor
      return count
    end

    def uri_params
      return super.merge(count: count)
    end

    def extract_uri_params(params)
      super
      self.count = (params["count"] || count).to_i
    end
  end
end
