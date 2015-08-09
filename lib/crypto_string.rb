class CryptoString
  def initialize
    raise "not implemented"
  end

  def self.from_base64(base64_string)
    @base64_string = base64_string
  end

  def self.from_hex(hex_string)
    @hex_string = hex_string
  end

  def self.from_plaintext(plaintext_string)
    raise "non-ascii characters" unless plaintext_string.ascii_only?
    @plaintext_string = plaintext_string
    @bytes = plaintext_string.bytes
  end
end
