require "test/unit"
require "otp"

class TestTOTP < Test::Unit::TestCase
  def assert_totp(totp, time, pass)
    totp.time = time
    assert_equal(pass, totp.password)
    assert(totp.verify(pass))
    assert(!totp.verify(pass.chop))
  end

  def test_totp_sha1
    seed = "12345678901234567890"
    totp = OTP::TOTP.new(OTP::Base32.encode(seed), "SHA1", 8)
    assert_totp(totp, 59,          "94287082")
    assert_totp(totp, 1111111109,  "07081804")
    assert_totp(totp, 1111111111,  "14050471")
    assert_totp(totp, 1234567890,  "89005924")
    assert_totp(totp, 2000000000,  "69279037")
    assert_totp(totp, 20000000000, "65353130")
  end

  def test_totp_sha256
    seed = "12345678901234567890123456789012"
    totp = OTP::TOTP.new(OTP::Base32.encode(seed), "SHA256", 8)
    assert_totp(totp, 59,          "46119246")
    assert_totp(totp, 1111111109,  "68084774")
    assert_totp(totp, 1111111111,  "67062674")
    assert_totp(totp, 1234567890,  "91819424")
    assert_totp(totp, 2000000000,  "90698825")
    assert_totp(totp, 20000000000, "77737706")
  end

  def test_totp_sha512
    seed = "1234567890123456789012345678901234567890123456789012345678901234"
    totp = OTP::TOTP.new(OTP::Base32.encode(seed), "SHA512", 8)
    assert_totp(totp, 59,          "90693936")
    assert_totp(totp, 1111111109,  "25091201")
    assert_totp(totp, 1111111111,  "99943326")
    assert_totp(totp, 1234567890,  "93441116")
    assert_totp(totp, 2000000000,  "38618901")
    assert_totp(totp, 20000000000, "47863826")
  end

  def test_last_and_post
    seed = "12345678901234567890"
    totp = OTP::TOTP.new(OTP::Base32.encode(seed), "SHA1", 8)
    totp.time = Time.at(1433502016)

    assert(!totp.verify("71170909"))
    assert(totp.verify("50451956"))  # current
    assert(!totp.verify("36432053"))

    assert(!totp.verify("79346509", last:2))
    assert(totp.verify("60048391", last:2))
    assert(totp.verify("71170909", last:2))
    assert(totp.verify("50451956", last:2))  # current
    assert(!totp.verify("36432053", last:2))

    assert(!totp.verify("71170909", post:2))
    assert(totp.verify("50451956", post:2))  # current
    assert(totp.verify("36432053", post:2))
    assert(totp.verify("78660635", post:2))
    assert(!totp.verify("97845627", post:2))

    assert(!totp.verify("79346509", last:2, post:2))
    assert(totp.verify("60048391", last:2, post:2))
    assert(totp.verify("71170909", last:2, post:2))
    assert(totp.verify("50451956", last:2, post:2))  # current
    assert(totp.verify("36432053", last:2, post:2))
    assert(totp.verify("78660635", last:2, post:2))
    assert(!totp.verify("97845627", last:2, post:2))
  end
end
