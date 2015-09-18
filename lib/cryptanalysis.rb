require_relative "crypto_string.rb"
module Xor_Cryptanalysis
  def self.single_character_xor(ciphertext)
    possibles = []
    (0...256).each do |value|
      possible_key = CryptoString.new([value])
      possible_solution = ciphertext.xor_with(possible_key)
      if possible_solution.english_string_score >= -100
        possibles << possible_solution
      end
    end

    possibles.sort do |a, b|
      b.english_string_score <=> a.english_string_score
    end
  end

  def self.calculate_key_length(string)
    key_length_candidates = []
    (1..40).each do |i|
      blocks = string.blocks(i)
      hamming_distance1 = blocks[0].hamming_distance(blocks[1])
      hamming_distance2 = blocks[1].hamming_distance(blocks[2])
      score = (hamming_distance1 + hamming_distance2).fdiv(i * 2)
      key_length_candidates << {
        key_length: i,
        score: score
      }
    end
    p key_length_candidates
    key_length_candidates.select { |candidate| candidate[:score] <= 3.3 } # adjust this number; down for performance, up if you don't see a good result
      .map { |candidate| candidate[:key_length] }
  end

  def self.detect_single_character_xor(strings)
    strings.map! { |string| string.chomp }
    results = []

    strings.each do |string|
      ciphertext = CryptoString.from_hex(string)
      possibles = single_character_xor(ciphertext)
      results += possibles
    end

    results.sort do |a, b|
      b.english_string_score <=> a.english_string_score
    end
  end

  def self.known_key_length_xor(string, key_length)
    split_strings = string.split(key_length)
    results = split_strings.map do |string_fragment|
      result = single_character_xor(string_fragment).first
      return nil if result.nil?
      result
    end
    CryptoString.unsplit(results)
  end

  def self.repeating_key_xor(string)
    key_length_candidates = calculate_key_length(string)
    candidates = []
    key_length_candidates.each do |key_length|
      p key_length
      result = known_key_length_xor(string, key_length)
      candidates << result unless result.nil?
    end
    candidates.sort do |a, b|
      b.english_string_score <=> a.english_string_score
    end
  end
end
