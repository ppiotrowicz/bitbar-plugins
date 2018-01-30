require 'json'

class Wallet
  include Enumerable

  def initialize(filename)
    wallet_file = File.join(__dir__, filename)
    load(wallet_file)
  end

  def each(&block)
    wallet.each do |key, value|
      block.call([key, value])
    end
  end

  private

  attr_reader :wallet

  def load(wallet_file)
    file = File.read(wallet_file)
    @wallet = JSON.parse(file)
  end
end

