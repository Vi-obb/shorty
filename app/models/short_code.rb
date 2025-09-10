class ShortCode
  SYMBOLS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".freeze
  BASE = SYMBOLS.length

  def self.encode(number)
    return SYMBOLS.first if number.zero? || number.nil?

    result = ""

    while number > 0 do
      index = number % BASE
      char = SYMBOLS[index]
      result.prepend char
      number = number / BASE
    end

    result
  end

  def self.decode(string)
    number = 0

    string.reverse.each_char.with_index do | char, index |
      power = BASE**index
      index = SYMBOLS.index(char)
      number += index * power
    end

    number
  end
end
