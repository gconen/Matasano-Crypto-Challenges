require "./constants"

def fixed_xor(hex1, hex2)
  result = ""
  hex1.each_char.with_index do |digit, index|
    result << (HEX_VALUE[digit] ^ HEX_VALUE[hex2[index]]).to_s
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  p fixed_xor(
    "1c0111001f010100061a024b53535009181c",
    "686974207468652062756c6c277320657965"
  )
end
