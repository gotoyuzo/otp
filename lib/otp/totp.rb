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

    def type_specific_uri_params
      params = {}
      params["period"] = period if period != DEFAULT_PERIOD
      return params
    end

    def extract_type_specific_uri_params(query)
      if value = query["period"]
        self.period = value.to_i
      end
    end
  end
end
