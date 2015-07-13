require "base64"
require "hex_base64"

def letter_values(letter)
  return 1 if %w(e t a o i n s r l u).include?(letter.downcase)
  0
end

def candidate_value(candidate)
end

def possibles(cipher_text)
  base64_cipher_text = hex_to_base64(cipher_text)
end
