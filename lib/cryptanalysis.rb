require_relative "crypto_string.rb"
module Xor_Cryptanalysis
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

  def self.calculate_key_length(string)

  end

  def self.detect_single_character_xor(filename)
    strings = File.readlines(filename)
    strings.map! { |string| string.chomp }
    results = []

    strings.each do |string|
      ciphertext = CryptoString.from_hex(string)
      possibles = Cryptanalysis.single_character_xor(ciphertext)
      results += possibles
    end

    results.sort do |a, b|
      b.english_string_score <=> a.english_string_score
    end
  end

  def self.known_key_length_xor(string, key_length)

  end

  def self.repeating_key_xor(string)
    key_length_candidates = calculate_key_length(string)
    candidates = []
    key_length_candidates.each do |key_length|
      candidates << known_key_length_xor(string, key_length)
    end

    candidates.sort do |a, b|
      b.english_string_score <=> a.english_string_score
    end
  end
end

results = Cryptanalysis.detect_single_character_xor("4.txt")
p results.map { |r| r.plaintext }
