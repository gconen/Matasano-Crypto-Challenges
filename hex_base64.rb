require "./constants.rb"

def hex_to_base64(hex)
  hex = hex.reverse
  num = 0
  hex.each_char.with_index do |digit, place|
    num += HEX_VALUE[digit] * (16 ** place)
  end
  base64 = ""
  until num == 0
    base64 << BASE64_ORDER[num % 64]
    num /= 64
  end

  base64.reverse
end

p hex_to_base64("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d")
