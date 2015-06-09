require_relative "helper"

class TestURI < Test::Unit::TestCase
  def test_parse
    uri = "otpauth://totp/account@example.com?secret=GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
    otp = OTP::URI.parse(uri)
    assert_equal("account@example.com", otp.accountname)
    assert_equal(nil, otp.issuer)

    uri = "otpauth://totp/account@example.com?secret=GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ&issuer=Foo"
    otp = OTP::URI.parse(uri)
    assert_equal("account@example.com", otp.accountname)
    assert_equal("Foo", otp.issuer)

    uri = "otpauth://totp/My%20Company:%20%20account@example.com?secret=GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
    otp = OTP::URI.parse(uri)
    assert_equal("account@example.com", otp.accountname)
    assert_equal("My Company", otp.issuer)

    uri = "otpauth://totp/My%20Company:%20%20account@example.com?secret=GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ&issuer=Foo"
    otp = OTP::URI.parse(uri)
    assert_equal("account@example.com", otp.accountname)
    assert_equal("My Company", otp.issuer)
  end

  def test_totp_simple
    secret = OTP::Base32.encode("12345678901234567890")
    totp = OTP::TOTP.new
    totp.secret = secret
    totp.accountname = "account@example.com"
    uri = totp.to_uri
    assert_not_match(/algorithm=/, uri)
    assert_not_match(/digits=/, uri)
    assert_not_match(/issuer=/, uri)
    assert_not_match(/period=/, uri)

    otp = OTP::URI.parse(uri)
    assert_equal(OTP::TOTP, otp.class)
    assert_equal(secret, otp.secret)
    assert_equal("SHA1", otp.algorithm)
    assert_equal(6, otp.digits)
    assert_equal(30, otp.period)
    assert_equal("account@example.com", otp.accountname)
    assert_equal(nil, otp.issuer)
    totp.time = otp.time = Time.now
    assert_equal(otp.password, totp.password)
  end

  def test_totp
    secret = OTP::Base32.encode("12345678901234567890")
    totp = OTP::TOTP.new
    totp.secret = secret
    totp.algorithm = "SHA256"
    totp.digits = 8
    totp.period = 60
    totp.issuer = "My Company"
    totp.accountname = "account@example.com"
    uri = totp.to_uri

    otp = OTP::URI.parse(uri)
    assert_equal(OTP::TOTP, otp.class)
    assert_equal(secret, otp.secret)
    assert_equal("SHA256", otp.algorithm)
    assert_equal(8, otp.digits)
    assert_equal(60, otp.period)
    assert_equal("account@example.com", otp.accountname)
    assert_equal("My Company", otp.issuer)
    totp.time = otp.time = Time.now
    assert_equal(otp.password, totp.password)
  end

  def test_hotp_simple
    secret = OTP::Base32.encode("12345678901234567890")
    hotp = OTP::HOTP.new
    hotp.secret = secret
    hotp.accountname = "account@example.com"
    uri = hotp.to_uri
    assert_not_match(/algorithm=/, uri)
    assert_not_match(/digits=/, uri)
    assert_not_match(/issuer=/, uri)
    assert_match(/count=0/, uri)

    otp = OTP::URI.parse(uri)
    assert_equal(OTP::HOTP, otp.class)
    assert_equal(secret, otp.secret)
    assert_equal("SHA1", otp.algorithm)
    assert_equal(6, otp.digits)
    assert_equal(0, otp.count)
    assert_equal("account@example.com", otp.accountname)
    assert_equal(nil, otp.issuer)
    assert_equal(otp.password, hotp.password)
  end

  def test_hotp
    secret = OTP::Base32.encode("12345678901234567890")
    hotp = OTP::HOTP.new
    hotp.secret = secret
    hotp.algorithm = "SHA256"
    hotp.digits = 8
    hotp.count = 1234
    hotp.issuer = "My Company"
    hotp.accountname = "account@example.com"
    uri = hotp.to_uri

    otp = OTP::URI.parse(uri)
    assert_equal(OTP::HOTP, otp.class)
    assert_equal(secret, otp.secret)
    assert_equal("SHA256", otp.algorithm)
    assert_equal(8, otp.digits)
    assert_equal(1234, otp.count)
    assert_equal("account@example.com", otp.accountname)
    assert_equal("My Company", otp.issuer)
    assert_equal(otp.password, hotp.password)
  end

  def test_parse_invalid
    e = assert_raise(RuntimeError){ OTP::URI.parse("http://www.netlab.jp") }
    assert_match(/URI scheme not match/, e.message)
    e = assert_raise(RuntimeError){ OTP::URI.parse("otpauth://foo") }
    assert_match(/unknown OTP type/, e.message)
    e = assert_raise(RuntimeError){ OTP::URI.parse("otpauth://version") }
    assert_match(/unknown OTP type/, e.message)
    e = assert_raise(RuntimeError){ OTP::URI.parse("otpauth://totp/") }
    assert_match(/account name must be present/, e.message)
  end
end
