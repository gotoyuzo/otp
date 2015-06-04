# One-Time Password Library

[![Build Status](https://secure.travis-ci.org/gotoyuzo/otp.png)](https://travis-ci.org/gotoyuzo/otp)
[![Gem Version](https://badge.fury.io/rb/otp.svg)](https://rubygems.org/gems/otp)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/gotoyuzo/otp/blob/master/LICENSE.txt)

This library provides an implementation of 
HMAC-Based One-Time Password Algorithm (HOTP; RFC4226) and
Time-Based One-Time Password Algorithm (HOTP; RFC6238).
The Algorithm details can be referred at the following URLs.

* HOTP: http://tools.ietf.org/html/rfc4226
* TOTP: http://tools.ietf.org/html/rfc6238

## Usage

To create new TOTP secret:

    require "otp"

    # Create a TOTP instance and new key
    totp = OTP::TOTP.new
    totp.new_secret  # create random secret
    p totp.password  #=> "123456" (password for the current time)

    # Inspect TOTP parameters
    p totp.secret    #=> "YVMR2G7N4OAXGKFC" (BASE32-formated HMAC key)
    p totp.algorithm #=> "SHA1" (HMAC algorithm; default SHA1)
    p totp.digits    #=> 6 (number of password digits; default 6)
    p totp.period    #=> 30 (time step period in second; default 30)
    p totp.time      #=> nil (UNIX time by Time or Integer; nil for the current time)

    # Format TOTP URI. Otpauth scheme URLs can be read by OTP::URI.parse.
    totp.issuer = "My Company"
    totp.accountname = "account@exaple.com"
    p totp.to_uri    #=> "otpauth://totp/My%20Company:account@exaple.com?secret=47JBA7ZWDDLNZJMX&issuer=My+Company"

To verify given TOTP password:

    require "otp"

    totp = OTP::TOTP.new
    totp.secret = "YVMR2G7N4OAXGKFC"
    p totp.verify("123456")  #=> true/false (verify given passowrd)

The value of "secret" is encoded with BASE32 algorithm to be compatible
with Google Authenticator URI format.

* BASE32: http://tools.ietf.org/html/rfc4648
* Google Authenticator Key URI format: https://github.com/google/google-authenticator/wiki/Key-Uri-Format
