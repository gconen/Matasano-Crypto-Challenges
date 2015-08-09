require 'rspec'
require 'crypto_string'

describe CryptoString do
  

  it "converts from hex-encoded strings to base64 encoded strings" do
    str = CryptoString.from_hex("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d")
    expect str.base64.to eq("SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t")
  end

end
