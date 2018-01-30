class Value
  def initialize(key:, current_rate:, amount:, current:, previous:, time:)
    @key = key
    @current_rate = current_rate
    @amount = amount
    @current = current
    @previous = previous
    @time = time
  end

  attr_reader :key, :current_rate, :amount, :current, :previous, :time
end
