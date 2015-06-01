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
  end
end
