require "test/unit"
require "otp"

class TestHTOP < Test::Unit::TestCase
  def test_hotp
    seed = "12345678901234567890"
    hotp = OTP::HOTP.new(OTP::Base32.encode(seed), "SHA1", 6)
    hotp.count = 0; assert_equal(hotp.password, "755224")
    hotp.count = 1; assert_equal(hotp.password, "287082")
    hotp.count = 2; assert_equal(hotp.password, "359152")
    hotp.count = 3; assert_equal(hotp.password, "969429")
    hotp.count = 4; assert_equal(hotp.password, "338314")
    hotp.count = 5; assert_equal(hotp.password, "254676")
    hotp.count = 6; assert_equal(hotp.password, "287922")
    hotp.count = 7; assert_equal(hotp.password, "162583")
    hotp.count = 8; assert_equal(hotp.password, "399871")
    hotp.count = 9; assert_equal(hotp.password, "520489")
  end
end
