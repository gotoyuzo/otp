require "test/unit"
require "otp/base32"

class TestBase32 < Test::Unit::TestCase
  def assert_encode(encoded, plain)
    assert_equal(encoded, ::OTP::Base32.encode(plain))
  end

  def assert_decode(plain, encoded)
    plain &&= plain.dup.force_encoding("binary")
    assert_equal(plain, ::OTP::Base32.decode(encoded))
  end

  def assert_encode_decode(plain, encoded)
    assert_decode(plain, encoded)
    assert_encode(encoded, plain)
  end

  def test_base32
    assert_encode_decode(nil, nil)
    assert_encode_decode("", "")
    assert_encode_decode("f", "MY======")
    assert_encode_decode("fo", "MZXQ====")
    assert_encode_decode("foo", "MZXW6===")
    assert_encode_decode("foob", "MZXW6YQ=")
    assert_encode_decode("fooba", "MZXW6YTB")
    assert_encode_decode("foobar", "MZXW6YTBOI======")
    assert_encode_decode("\u{3042}\u{3044}\u{3046}\u{3048}\u{304a}", "4OAYFY4BQTRYDBXDQGEOHAMK")
  end

  def test_truncated_decode
    assert_decode("f", "MY")
    assert_decode("fo", "MZXQ")
    assert_decode("foo", "MZXW6")
    assert_decode("foob", "MZXW6YQ")
    assert_decode("f", "my")
    assert_decode("fo", "mzxq")
    assert_decode("foo", "mzxw6")
    assert_decode("foob", "mzxw6yq")
  end

  def test_unspecified
    assert_raise(ArgumentError){ OTP::Base32.decode("MY0") }
    assert_decode("", "=")
    assert_decode("", "M=======")
    assert_decode("f", "MZX=====")
    assert_decode("foo", "MZXW6Y==")
    assert_decode("", "M")
    assert_decode("f", "MZX")
    assert_decode("foo", "MZXW6Y")
    assert_decode("fooba", "MZXW6YTB===")
    assert_decode("f", "MY=AAAAA")
    assert_decode("fo", "MZXQ=AAA")
    assert_decode("foo", "MZXW6=AA")
    assert_decode("foo", "MZXW6=00")
  end
end
