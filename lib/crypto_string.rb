require "base64"

class CryptoString

  attr_reader :bytes

  def initialize(bytes = nil)
    @bytes = bytes
  end

  def self.from_base64(base64_string)
    str = CryptoString.new
    str.set_base64(base64_string)
  end

  def self.from_hex(hex_string)
    str = CryptoString.new
    str.set_hex(hex_string)
  end

  def self.from_plaintext(plaintext_string)
    raise "non-ascii characters" unless plaintext_string.ascii_only?
    str = CryptoString.new
    str.set_plaintext(plaintext_string)
  end

  def base64
    return @base64_string if @base64_string

    @base64_string = Base64.strict_encode64(plaintext)
  end

  def hex
    return @hex_string if @hex_string

    @hex_string = @bytes.map{ |byte| byte.to_s(16) }.join("")
  end

  def plaintext
    return @plaintext if @plaintext
    @plaintext = @bytes.pack("C*")
  end

  def set_base64(base64_string)
    #clear not needed because it's in set_plaintext
    set_plaintext(Base64.strict_decode64(base64_string))
    @base64_string = base64_string

    self
  end

  def set_hex(hex_string)
    clear
    @hex_string = hex_string
    @bytes = hex_string.scan(/../).map { |byte| byte.to_i(16) }

    self
  end

  def set_plaintext(plaintext_string)
    raise "non-ascii characters" unless plaintext_string.ascii_only?

    clear
    @plaintext = plaintext_string
    @bytes = plaintext_string.bytes

    self
  end

  def equal_length_xor(other_string)
    new_bytes = []
    bytes.each_index do |i|
      new_bytes[i] = bytes[i] ^ other_string.bytes[i]
    end

    CryptoString.new(new_bytes)
  end

  private
  def clear
    @plaintext = nil
    @hex_string = nil
    @base64_string = nil
  end

end
