require "test/unit"
require "otp/base32"

class TestBase32 < Test::Unit::TestCase
  def test_encode
   assert_equal(::OTP::Base32.encode(""), "")
   assert_equal(::OTP::Base32.encode("f"), "MY======")
   assert_equal(::OTP::Base32.encode("fo"), "MZXQ====")
   assert_equal(::OTP::Base32.encode("foo"), "MZXW6===")
   assert_equal(::OTP::Base32.encode("foob"), "MZXW6YQ=")
   assert_equal(::OTP::Base32.encode("fooba"), "MZXW6YTB")
   assert_equal(::OTP::Base32.encode("foobar"), "MZXW6YTBOI======")
  end

  def test_decode
   assert_equal(::OTP::Base32.decode(""), "")
   assert_equal(::OTP::Base32.decode("MY======"), "f")
   assert_equal(::OTP::Base32.decode("MZXQ===="), "fo")
   assert_equal(::OTP::Base32.decode("MZXW6==="), "foo")
   assert_equal(::OTP::Base32.decode("MZXW6YQ="), "foob")
   assert_equal(::OTP::Base32.decode("MZXW6YTB"), "fooba")
   assert_equal(::OTP::Base32.decode("MZXW6YTBOI======"), "foobar")
  end
end
