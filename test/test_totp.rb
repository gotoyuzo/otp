require "test/unit"
require "otp"

class TestTOTP < Test::Unit::TestCase
  def test_totp_sha1
    seed = "12345678901234567890"
    totp = OTP::TOTP.new(OTP::Base32.encode(seed), "SHA1", 8)
    totp.time = 59;          assert_equal(totp.password, "94287082")
    totp.time = 1111111109;  assert_equal(totp.password, "07081804")
    totp.time = 1111111111;  assert_equal(totp.password, "14050471")
    totp.time = 1234567890;  assert_equal(totp.password, "89005924")
    totp.time = 2000000000;  assert_equal(totp.password, "69279037")
    totp.time = 20000000000; assert_equal(totp.password, "65353130")
  end

  def test_totp_sha256
    seed = "12345678901234567890123456789012"
    totp = OTP::TOTP.new(OTP::Base32.encode(seed), "SHA256", 8)
    totp.time = 59;          assert_equal(totp.password, "46119246")
    totp.time = 1111111109;  assert_equal(totp.password, "68084774")
    totp.time = 1111111111;  assert_equal(totp.password, "67062674")
    totp.time = 1234567890;  assert_equal(totp.password, "91819424")
    totp.time = 2000000000;  assert_equal(totp.password, "90698825")
    totp.time = 20000000000; assert_equal(totp.password, "77737706")
  end

  def test_totp_sha512
    seed = "1234567890123456789012345678901234567890123456789012345678901234"
    totp = OTP::TOTP.new(OTP::Base32.encode(seed), "SHA512", 8)
    totp.time = 59;          assert_equal(totp.password, "90693936")
    totp.time = 1111111109;  assert_equal(totp.password, "25091201")
    totp.time = 1111111111;  assert_equal(totp.password, "99943326")
    totp.time = 1234567890;  assert_equal(totp.password, "93441116")
    totp.time = 2000000000;  assert_equal(totp.password, "38618901")
    totp.time = 20000000000; assert_equal(totp.password, "47863826")
  end
end
