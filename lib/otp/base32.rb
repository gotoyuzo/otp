module OTP
  module Base32
    BASE32_ENCODE = %w(
      A B C D E F G H I J K L M N O P
      Q R S T U V W X Y Z 2 3 4 5 6 7
    )

    BASE32_DECODE = {
      ?A=>0,  ?B=>1,  ?C=>2,  ?D=>3,  ?E=>4,  ?F=>5,  ?G=>6,  ?H=>7, 
      ?I=>8,  ?J=>9,  ?K=>10, ?L=>11, ?M=>12, ?N=>13, ?O=>14, ?P=>15,
      ?Q=>16, ?R=>17, ?S=>18, ?T=>19, ?U=>20, ?V=>21, ?W=>22, ?X=>23, 
      ?Y=>24, ?Z=>25, ?2=>26, ?3=>27, ?4=>28, ?5=>29, ?6=>30, ?7=>31, 
      ?==>-1,
    }

    module_function

    def encode(bytes)
      return nil unless bytes
      ret = ""
      bytes = bytes.dup.force_encoding("binary")
      off = 0
      while off < bytes.length
        n = 0
        bits = bytes[off, 5]
        l = (bits.length * 8.0 / 5.0).ceil
        bits << "\0" while bits.length < 5
        bits.each_byte{|b| n = (n << 8) | b }
        (1..8).each do |i|
          ret << ((i > l) ? ?= : BASE32_ENCODE[(n >> (8-i)*5) & 0x1f])
        end
        off += 5
      end
      return ret
    end

    def decode(chars)
      return nil unless chars
      ret = ""
      chars = chars.upcase
      ret.force_encoding("binary")
      off = 0
      while off < chars.length
        n = l = 0
        bits = chars[off, 8]
        bits << "=" while bits.length < 8
        bits.each_char.with_index do |c, i|
          d = BASE32_DECODE[c]
          raise ArgumentError, "invalid char: #{c}" unless d
          if d < 0
            n <<= 5 * (8-i)
            break
          end
          n <<= 5
          n |= d
          l = ((i+1) * 5.0 / 8.0).floor
        end
        ret << (1..l).map{|i| (n >> 40 - i * 8) & 0xff }.pack("c*")
        off += 8
      end
      return ret
    end
  end
end
