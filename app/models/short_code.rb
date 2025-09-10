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
  end
end
