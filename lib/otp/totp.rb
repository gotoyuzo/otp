require "otp/base"

module OTP
  class TOTP < OTP::Base
    attr_accessor :period, :time

    DEFAULT_PERIOD = 30

    def initialize(*args)
      super
      self.period = DEFAULT_PERIOD
      self.time = nil
    end

    def moving_factor
      return (time || Time.now).to_i / period
    end

    def uri_params
      params = super
      params["period"] = period if period != DEFAULT_PERIOD
      return params
    end

    def extract_uri_params(params)
      super
      self.period = (params["period"] || period).to_i
    end
  end
end
