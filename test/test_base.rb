require_relative "helper"

class TestBase < Test::Unit::TestCase
  def test_new_secret
    otp = OTP::Base.new

    otp.new_secret(20)
    assert_equal(20, otp.raw_secret.length)
    assert_equal(32, otp.secret.length)

    otp.new_secret(40)
    assert_equal(40, otp.raw_secret.length)
    assert_equal(64, otp.secret.length)
  end

  def test_secret
    otp = OTP::Base.new

    otp.secret = nil
    assert_nil(otp.secret)
    assert_nil(otp.raw_secret)

    otp.secret = ""
    assert_equal("", otp.secret)
    assert_equal("", otp.raw_secret)

    otp.secret = "MZXW6YTBOI======"
    assert_equal("MZXW6YTBOI======", otp.secret)
    assert_equal("foobar", otp.raw_secret)

    otp.secret = "MZXW6YTBOI"
    assert_equal("MZXW6YTBOI", otp.secret)
    assert_equal("foobar", otp.raw_secret)
  end

  def test_raw_secret
    otp = OTP::Base.new

    otp.raw_secret = nil
    assert_nil(otp.secret)
    assert_nil(otp.raw_secret)

    otp.raw_secret = ""
    assert_equal("", otp.secret)
    assert_equal("", otp.raw_secret)

    otp.raw_secret = "foobarbaz"
    assert_equal("MZXW6YTBOJRGC6Q=", otp.secret)
    assert_equal("foobarbaz", otp.raw_secret)
  end

  def test_methods_expected_to_be_override
    base = OTP::Base.new
    hotp = OTP::HOTP.new
    totp = OTP::TOTP.new
    [
      [:moving_factor, ],
      [:type_specific_uri_params, ],
      [:extract_type_specific_uri_params, {}],
    ].each do |m, *args|
      assert_raise(NotImplementedError){ base.send(m, *args) }
      assert_nothing_raised{ hotp.send(m, *args) }
      assert_nothing_raised{ totp.send(m, *args) }
    end
  end
end
