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

  def self.detect_single_character_xor(filename)
    strings = File.readlines(filename)
    strings.map! { |string| string.chomp }
    results = []

    strings.each do |string|
      ciphertext = CryptoString.from_hex(string)
      p ciphertext.hex
      possibles = Cryptanalysis.single_character_xor(ciphertext)
      results += possibles
    end

    results.sort do |a, b|
      b.english_string_score <=> a.english_string_score
    end
  end
end

results = Cryptanalysis.detect_single_character_xor("4.txt")
p results.map { |r| r.plaintext }
