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

    @hex_string = @bytes.map{ |byte| byte.to_s(16).rjust(2, "0") }.join("")
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

  def ==(other)
    return false unless other.kind_of?(CryptoString)
    bytes == other.bytes
  end

  def [](index)
    if index.kind_of?(Integer)
      return CryptoString.new([bytes[index]])
    elsif index.kind_of?(Range)
      return CryptoString.new(bytes[index])
    else
      raise ArgumentError
    end
  end

  def equal_length_xor(other_string) #probably better to use #xor_with externally
    new_bytes = []                    #make private?
    bytes.each_index do |i|
      new_bytes[i] = bytes[i] ^ other_string.bytes[i]
    end

    CryptoString.new(new_bytes)
  end

  def english_string_score
    ascii_values_of_common_characters = #etainshrdlu and space
          [101, 116, 105, 97, 110, 115, 104, 100, 108, 117, 32]
    score = 0
    bytes.each do |byte|
      score -= 1 unless byte.between?(97, 121) || byte == 32 #lower-case letters and space
      score += 1 if ascii_values_of_common_characters.include?(byte)
    end

    score
  end

  def length
    bytes.length
  end

  def hamming_distance(other)
    self.xor_with(other).one_bit_count
  end

  def xor_with(other)
    other_bytes = other.bytes.dup
    while other_bytes.length < length
      other_bytes.concat(other_bytes)
    end

    equal_length_xor(CryptoString.new(other_bytes))
  end

  protected
  def one_bit_count
    sum = 0
    bytes.each do |byte|
       sum += byte.to_s(2).count("1")
    end

    sum
  end

  private
  def clear
    @plaintext = nil
    @hex_string = nil
    @base64_string = nil
  end


end
