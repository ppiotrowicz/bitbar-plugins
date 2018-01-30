class Formatter
  def self.format_main(value)
    color, symbol, amount = get_delta(value.current, value.previous) 
    puts "#{money(value.current)} #{symbol} #{money(amount)} | color=#{color} font=InputMonoCondensed"
  end

  def self.format_sub(values)
    values.each do |value|
      format(value)
    end
  end

  def self.separator
    puts '---'
  end

  def self.open_bitbay
    puts "Open BitBay | href=https://app.bitbay.net"
  end

  def self.format_tracked(values)
    values.each do |value|
      format(value)
    end
  end

  def self.header
    puts "  symbol  #{'current'.rjust(12)} #{'change'.rjust(8)} | font=InputMonoCondensed size=12 trim=false"
  end

  private

  def self.format(value)
    color, symbol, amount = get_delta(value.current, value.previous) 
    puts "#{symbol} #{value.key} #{money(value.current).rjust(12)} #{money(amount).rjust(8)} | color=#{color} #{url(value.key)} font=InputMonoCondensed size=12"
  end

  def self.get_delta(current, previous)
    return ['white', '=', 0.0] if current == previous
    return ['green', '▲', current - previous] if current > previous
    return ['red', '▼', previous - current] if current < previous
  end

  def self.url(key)
    map = {
      'BTC' => 'bitcoin',
      'LSK' => 'lisk',
      'LTC' => 'litecoin',
      'ETH' => 'ethereum',
      'USD' => 'usd',
      'PLN' => 'pln'
    }

    from, to = key.split('-')
    "href=https://bitbay.net/en/exchange-rate/#{map[from]}-price-#{map[to]}" if from && to
  end

  def self.money(value)
    MoneyFormatter.new(value).format
  end

  class MoneyFormatter
    DEFAULT_DELIMITER_REGEX = /(\d)(?=(\d\d\d)+(?!\d))/

    def initialize(number)
      @number = '%.2f' % number
    end

    def format
      parts.join('.')
    end

    private

    attr_reader :number

    def parts
      left, right = number.split('.')
      left.gsub!(delimiter_pattern) do |digit_to_delimit|
        "#{digit_to_delimit} "
      end
      [left, right].compact
    end

    def delimiter_pattern
      DEFAULT_DELIMITER_REGEX
    end
  end
end
