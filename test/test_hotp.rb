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

  def test_last_and_post
    seed = "12345678901234567890"
    hotp = OTP::HOTP.new(OTP::Base32.encode(seed), "SHA1", 6)
    hotp.count = 5

    assert(!hotp.verify("359152", last:2))  # pass for 2
    assert(hotp.verify("969429", last:2))  # pass for 3
    assert(hotp.verify("338314", last:2))  # pass for 4
    assert(hotp.verify("254676", last:2))  # pass for 5
    assert(!hotp.verify("287922", last:2))  # pass for 6

    assert(!hotp.verify("338314", post:2))  # pass for 4
    assert(hotp.verify("254676", post:2))  # pass for 5
    assert(hotp.verify("287922", post:2))  # pass for 6
    assert(hotp.verify("162583", post:2))  # pass for 7
    assert(!hotp.verify("399871", post:2))  # pass for 8

    assert(!hotp.verify("359152", last:2, post:2))  # pass for 2
    assert(hotp.verify("969429", last:2, post:2))  # pass for 3
    assert(hotp.verify("338314", last:2, post:2))  # pass for 4
    assert(hotp.verify("254676", post:2, post:2))  # pass for 5
    assert(hotp.verify("287922", post:2, post:2))  # pass for 6
    assert(hotp.verify("162583", post:2, post:2))  # pass for 7
    assert(!hotp.verify("399871", post:2, post:2))  # pass for 8
  end
end
