require 'cryptanalysis'
describe Xor_Cryptanalysis do
  let(:shelley) { CryptoString.from_plaintext(File.read("shelley.txt")) }
  context "single character xor" do
    it "decrypts single character xor ciphers" do
      ciphertext = CryptoString.from_hex(
        "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
      )
      result = Xor_Cryptanalysis.single_character_xor(ciphertext).first
      expect(result.plaintext).to eq("Cooking MC's like a pound of bacon")
    end

    it "detects single character xor ciphers" do
      possibles = File.readlines("4.txt")
      result = Xor_Cryptanalysis.detect_single_character_xor(possibles).first
      expect(result.plaintext).to eq("Now that the party is jumping\n")
    end
  end
  context "repeating key xor" do
    it "detects the proper key length for repeating key xor" do
      #slightly non-deterministic, but should pass almost all the time.
      10.times do
        length_5_key = CryptoString.new(Array.new(5) { rand(128) })
        length_10_key = CryptoString.new(Array.new(10) { rand(128) })
        length_5 = shelley.xor_with(length_5_key)
        length_10 = shelley.xor_with(length_10_key)
        expect(Xor_Cryptanalysis.calculate_key_length(length_5)).to include(5)
        expect(Xor_Cryptanalysis.calculate_key_length(length_10)).to include(10)
      end
    end

    it "decrypts ciphertext with a known key length" do
      # 10.times do
        length_5_key = CryptoString.new(Array.new(5) { rand(128) })
        # length_10_key = CryptoString.new(Array.new(10) { rand(128) })
        length_5 = shelley.xor_with(length_5_key)
        # length_10 = shelley.xor_with(length_10_key)
        expect(Xor_Cryptanalysis.known_key_length_xor(length_5, 5).plaintext).to eq(shelley.plaintext)
        # expect(Xor_Cryptanalysis.known_key_length_xor(length_10, 10)).to eq(shelley)
      # end
    end
  end
end
