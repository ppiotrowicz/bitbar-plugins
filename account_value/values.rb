class Values
  def initialize(ticker, wallet)
    @values = wallet.map do |key, amount|
      d = ticker[key]
      rate = BigDecimal(d['rate'])
      previous_rate = BigDecimal(d['previousRate'])
      current = (rate * amount).round(2)
      previous = (previous_rate * amount).round(2)
      time = Time.at(d['time'].to_i / 1000)

      Value.new(
        key: key,
        current_rate: rate,
        amount: amount,
        current: current,
        previous: previous,
        time: time
      )
    end
    
    @total = Value.new(
      key: 'PLN',
      current_rate: nil,
      amount: nil,
      current: @values.reduce(0) { |memo, v| memo + v.current },
      previous: @values.reduce(0) { |memo, v| memo + v.previous },
      time: Time.now.utc
    )
  end

  attr_reader :values, :total
end
