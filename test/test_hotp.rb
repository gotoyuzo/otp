require "test/unit"
require "otp"

class TestHTOP < Test::Unit::TestCase
  def assert_hotp(hotp, count, pass)
    hotp.count = count
    assert_equal(pass, hotp.password)
    assert(hotp.verify(pass))
    assert(!hotp.verify(pass.chop))
  end

  def test_hotp
    seed = "12345678901234567890"
    hotp = OTP::HOTP.new(OTP::Base32.encode(seed), "SHA1", 6)
    assert_hotp(hotp, 0, "755224")
    assert_hotp(hotp, 1, "287082")
    assert_hotp(hotp, 2, "359152")
    assert_hotp(hotp, 3, "969429")
    assert_hotp(hotp, 4, "338314")
    assert_hotp(hotp, 5, "254676")
    assert_hotp(hotp, 6, "287922")
    assert_hotp(hotp, 7, "162583")
    assert_hotp(hotp, 8, "399871")
    assert_hotp(hotp, 9, "520489")
  end
end
