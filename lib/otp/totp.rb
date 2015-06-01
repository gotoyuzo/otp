require "otp/base"

module OTP
  class TOTP < OTP::Base
    attr_accessor :period, :time

    def initialize(*args)
      super
      self.period = 30
      self.time = nil
    end

    def moving_factor
      return (time || Time.now).to_i / period
    end
  end
end
