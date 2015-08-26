require 'crypto_string'

describe CryptoString do
  context "creates a byte array" do
    it "from plaintext" do
      str = CryptoString.from_plaintext("Lorem")
      expect(str.bytes).to eq([76, 111, 114, 101, 109])
    end

    it "from hex-encoded strings" do
      str = CryptoString.from_hex("4C6F72656D")
      expect(str.bytes).to eq([76, 111, 114, 101, 109])
    end

    it "from base64-encoded strings" do
      str = CryptoString.from_base64("TG9yZW0=")
      expect(str.bytes).to eq([76, 111, 114, 101, 109])
    end
  end

  context "recovers hex-encoded string" do
    it "creates a hex-encoded string from an array of bytes" do
      str = CryptoString.new([76, 111, 114, 101, 109])
      expect(str.hex.upcase).to eq("4C6F72656D")
    end

    it "recovers the same hex-encoded string" do
      str = CryptoString.from_hex("4C6F72656D")
      expect(str.hex.upcase).to eq("4C6F72656D")
    end

    it "converts plaintext to hex encoded strings" do
      str = CryptoString.from_plaintext("Lorem")
      expect(str.hex.upcase).to eq("4C6F72656D")
    end

    it "converts base64 strings to hex strings" do
      str = CryptoString.from_base64("SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t")
      expect(str.hex).to eq("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d")
    end
  end

  context "recovers plaintext" do
    it "recovers the same plaintext string" do
      str = CryptoString.from_plaintext("Lorem")
      expect(str.plaintext).to eq("Lorem")
    end

    it "converts hex-encoded strings to plaintext strings" do
      str = CryptoString.from_hex("4C6F72656D")
      expect(str.plaintext).to eq("Lorem")
    end
  end

  context "recovers base64" do
    it "recovers the same base64 string" do
      str = CryptoString.from_base64("TG9yZW0=")
      expect(str.base64).to eq("TG9yZW0=")
    end

    it "converts hex-encoded strings to base64-encoded strings" do
      str = CryptoString.from_hex("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d")
      expect(str.base64).to eq("SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t")
    end
  end

  context "basic string operations" do
    let(:str_plain) { CryptoString.from_plaintext("Lorem") }
    let(:str_hex) { CryptoString.from_hex("4C6F72656D") }
    let(:str_base64) { CryptoString.from_base64("TG9yZW0=") }
    let(:str_bytes) { CryptoString.new([76, 111, 114, 101, 109]) }

    it "has a length equal to its length in bytes" do
      expect(str_plain.length).to eq(5)
      expect(str_bytes.length).to eq(5)
      expect(str_hex.length).to eq(5)
      expect(str_base64.length).to eq(5)

    end

    context "equality" do
      it "is not equal to other types of object" do
        expect(str_plain == "Lorem").to be false
      end

      it "is equal to other CryptoStrings with the same content" do
        expect(str_plain == str_hex).to be true
        expect(str_base64 == str_hex).to be true
        expect(str_plain == str_base64).to be true
        expect(str_plain == str_bytes).to be true
        expect(str_hex == str_bytes).to be true
        expect(str_base64 == str_bytes).to be true
      end

      it "is not equal to other CryptoStrings with diffent content" do
        str_other = CryptoString.from_plaintext("Not Equal")
        expect(str_plain == str_other).to be false
      end
    end

    context "[]" do
      let(:str) { CryptoString.from_plaintext("Lorem") }

      it "returns a single byte at an integer index" do
        byte = str[2]

        expect(byte.plaintext).to eq("r")
      end

      it "returns a sub-CryptoString at a range of indices" do
        sub_str = str[2...5]

        expect(sub_str.plaintext).to eq("rem")
      end
    end
  end

  context "xor ciphers" do
    it "can xor itself with another CryptoString of equal length" do
      str1 = CryptoString.from_hex("1c0111001f010100061a024b53535009181c")
      str2 = CryptoString.from_hex("686974207468652062756c6c277320657965")

      result = str1.equal_length_xor(str2)
      expect(result.hex).to eq("746865206b696420646f6e277420706c6179")
    end

    it "can xor itself with a shorter CryptoString" do
      str1 = CryptoString.from_plaintext("Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal")
      str2 = CryptoString.from_plaintext("ICE")

      str3 = str1.xor_with(str2)

      expect(str3.hex).to eq("0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f")
    end

    it "can xor itself with a longer CryptoString" do
      str1 = CryptoString.new([76, 111, 114, 101, 109])
      str2 = CryptoString.new([97, 98, 99, 100, 101, 102, 103, 104])

      str3 = str1.xor_with(str2)

      expect(str3.bytes).to eq([45, 13, 17, 1, 8])
    end
  end

  it "calculates Hamming distance" do
    str1 = CryptoString.from_plaintext("this is a test")
    str2 = CryptoString.from_plaintext("wokka wokka!!!")

    expect(str1.hamming_distance(str2)).to eq(37)
  end
end
