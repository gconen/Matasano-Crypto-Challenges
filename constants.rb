HEX_VALUE = {
  "0" => 0,
  "1" => 1,
  "2" => 2,
  "3" => 3,
  "4" => 4,
  "5" => 5,
  "6" => 6,
  "7" => 7,
  "8" => 8,
  "9" => 9,
  "a" => 10,
  "b" => 11,
  "c" => 12,
  "d" => 13,
  "e" => 14,
  "f" => 15
}
BASE64_ORDER = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

values = {}

BASE64_ORDER.each_char.with_index do |char, index|
  values[char] = index
end

BASE64_VALUES = values
