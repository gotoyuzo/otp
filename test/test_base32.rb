require_relative "helper"

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
    assert_encode_decode("f", "MY")
    assert_encode_decode("fo", "MZXQ")
    assert_encode_decode("foo", "MZXW6")
    assert_encode_decode("foob", "MZXW6YQ")
    assert_encode_decode("fooba", "MZXW6YTB")
    assert_encode_decode("foobar", "MZXW6YTBOI")
    assert_encode_decode("\u{3042}\u{3044}\u{3046}\u{3048}\u{304a}", "4OAYFY4BQTRYDBXDQGEOHAMK")
  end

  def test_decode_with_mistyped
    assert_decode(OTP::Base32.decode("AOLB"), "A018")
    assert_decode(OTP::Base32.decode("aolb"), "A018")
  end

  def test_decode_include_space
    assert_decode("f", "M Y")
    assert_decode("fo", "MZ XQ")
    assert_decode("foo", "M\nZ\rX\tW-6")
    assert_decode("f", "m y")
    assert_decode("fo", "mz xq")
    assert_decode("foo", "m\nz\rx\tw-6")
  end

  def test_unspecified
    e = assert_raise(ArgumentError){ OTP::Base32.decode("MY9") }
    assert_equal("invalid char: 9", e.message)
    assert_decode("", "=")
    assert_decode("", "M=======")
    assert_decode("f", "MZX=====")
    assert_decode("foo", "MZXW6Y==")
    assert_decode("", "M=======G")
    assert_decode("f", "MZX=====G")
    assert_decode("foo", "MZXW6Y==G")
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
