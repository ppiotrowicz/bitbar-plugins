#!/usr/bin/env ruby
# <bitbar.title>Spekulant Bar 2.0</bitbar.title>
# <bitbar.version>v2.0</bitbar.version>
# <bitbar.dependencies>ruby</bitbar.dependencies>
# <bitbar.author>Pawel Piotrowicz</bitbar.author>
# <bitbar.author.github>ppiotrowicz</bitbar.author.github>
# <bitbar.desc>Shows current value of bitbay wallet</bitbar.desc>

require 'bigdecimal'
require_relative 'account_value/ticker'
require_relative 'account_value/wallet'
require_relative 'account_value/value'
require_relative 'account_value/values'
require_relative 'account_value/formatter'


ticker  = Ticker.new.fetch
if ticker.nil?
  puts ":boom:"
  exit 0
end

wallet  = Wallet.new('wallet.json')
values  = Values.new(ticker, wallet)

other   = Wallet.new('tracked.json')
tracked = Values.new(ticker, other)

Formatter.format_main(values.total)
Formatter.separator
Formatter.open_bitbay
Formatter.separator
Formatter.header
Formatter.separator
Formatter.format_sub(values.values)
Formatter.separator
Formatter.format_sub(tracked.values)
