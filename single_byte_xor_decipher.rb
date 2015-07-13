require "base64"
require "hex_base64"

def letter_values(letter)
  return 1 if %w(e t a o i n s r l u).include?(letter.downcase)
  0
end

def candidate_value(candidate)
  value = 0
  candidate.each do |char|
    value += letter_values(Base64.decode64(char))
  end
end

def possibles(cipher_text)
  base64_cipher_text = hex_to_base64(cipher_text)
  possibles = []
  (0...64).each do |possible_encryption_key|
    possible = []
    cipher_text.each_char do |char|
      possible << char ^ possible_encryption_key
    end
    possibles << possible
  end

  possibles
end


def decrypt(cipher_text)
  candidates = possibles(cipher_text)

  candidates.sort { |a, b| candidate_value(a) <=> candidate_value(b) }
end
