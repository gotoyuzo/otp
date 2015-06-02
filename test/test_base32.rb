require "test/unit"
require "otp/base32"

class TestBase32 < Test::Unit::TestCase
  def assert_encode(plain, encoded)
     assert_equal(::OTP::Base32.encode(plain), encoded)
  end

  def assert_decode(encoded, plain)
     assert_equal(::OTP::Base32.decode(encoded), plain)
  end

  def assert_encode_decode(plain, encoded)
    plain.force_encoding("binary")
    assert_encode(plain, encoded)
    assert_decode(encoded, plain)
  end

  def test_base32
    assert_encode_decode("", "")
    assert_encode_decode("f", "MY======")
    assert_encode_decode("fo", "MZXQ====")
    assert_encode_decode("foo", "MZXW6===")
    assert_encode_decode("foob", "MZXW6YQ=")
    assert_encode_decode("fooba", "MZXW6YTB")
    assert_encode_decode("foobar", "MZXW6YTBOI======")
    assert_encode_decode("\u{3042}\u{3044}\u{3046}\u{3048}\u{304a}", "4OAYFY4BQTRYDBXDQGEOHAMK")
  end
end
