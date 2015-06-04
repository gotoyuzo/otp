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

    def type_specific_uri_params
      return {count: count}
    end

    def extract_type_specific_uri_params(query)
      if value = query["count"]
        self.count = value.to_i
      end
    end
  end
end
