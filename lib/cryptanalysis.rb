require_relative "crypto_string.rb"
class Cryptanalysis
  def self.single_character_xor(ciphertext)
    possibles = []
    (1...128).each do |value|
      possible_key = CryptoString.new([value])
      possible_solution = ciphertext.xor_with(possible_key)
      if possible_solution.english_string_score >= 0
        possibles << possible_solution
      end
    end

    possibles.sort do |a, b|
      b.english_string_score <=> a.english_string_score
    end
  end
end

ciphertext = CryptoString.from_hex("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736")
possibles = Cryptanalysis.single_character_xor(ciphertext)
p possibles.map { |pos| pos.plaintext }
