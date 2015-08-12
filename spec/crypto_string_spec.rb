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

  it "can xor itself with another CryptoString of equal length" do
    str1 = CryptoString.from_hex("1c0111001f010100061a024b53535009181c")
    str2 = CryptoString.from_hex("686974207468652062756c6c277320657965")

    result = str1.equal_length_xor(str2)
    expect(result.hex).to eq("746865206b696420646f6e277420706c6179")
  end

end
