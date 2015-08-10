class CryptoString
  
  attr_reader :bytes

  def initialize
  end

  def self.from_base64(base64_string)
    str.base64_string = base64_string

    str
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

  def hex
    return @hex_string if @hex_string

    @bytes.map{ |byte| byte.to_s(16) }.join("")
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

  private
  def clear
    @plaintext = nil
    @hex_string = nil
    @base64_string = nil
  end

end
