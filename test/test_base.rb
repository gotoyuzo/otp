require_relative "helper"

class TestBase < Test::Unit::TestCase
  def test_base
    otp = OTP::Base.new
    otp.new_secret(20)
    assert_equal(32, otp.secret.length)
    otp.new_secret(40)
    assert_equal(64, otp.secret.length)
  end

  def test_methods_expected_to_be_override
    base = OTP::Base.new
    totp = OTP::TOTP.new

    [
      [:moving_factor, ],
      [:type_specific_uri_params, ],
      [:extract_type_specific_uri_params, {}],
    ].each do |m, *args|
      assert_raise(NotImplementedError){ base.send(m, *args) }
      assert_nothing_raised{ totp.send(m, *args) }
    end
  end
end
