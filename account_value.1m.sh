#!/usr/bin/env ruby
# <bitbar.title>Spekulant Bar 2.0</bitbar.title>
# <bitbar.version>v2.0</bitbar.version>
# <bitbar.dependencies>ruby</bitbar.dependencies>
# <bitbar.author>Pawel Piotrowicz</bitbar.author>
# <bitbar.author.github>ppiotrowicz</bitbar.author.github>
# <bitbar.desc>Shows wallet status</bitbar.desc>

require 'open-uri'
require 'json'

data = open('https://api.bitbay.net/rest/trading/ticker') { |f| f.read }
ticker = JSON.parse(data)
items = ticker['items']
items.merge!('PLN-PLN' => { 'rate' => 1 , 'previousRate' => 1})

lines = File.readlines(File.join(__dir__, 'wallet.json')).join
wallet = JSON.parse(lines)

def get_delta(current, last)
  if current != last
    delta = current - last
    if delta.positive?
      { color: 'green', symbol: '▲', amount: delta.abs }
    else
      { color: 'red', symbol: '▼', amount: delta.abs }
    end
  else
    { color: 'white', symbol: '=', amount: 0.0 }
  end

end

values = wallet.map do |currency, amount|
  d = items[currency]
  rate = d['rate'].to_i
  prev_rate = d['previousRate'].to_i
  value = (rate * amount).round(2)
  prev_value = (prev_rate * amount).round(2)
  { key: currency, rate: rate, amount: amount, value: value, prev_value: prev_value }
end

total = values.reduce(0) { |memo, v| memo + v[:value] }
prev_total = values.reduce(0) { |memo, v| memo + v[:prev_value] }
delta = get_delta(total, prev_total) 
symbol = delta[:symbol]
color = delta[:color]
amount = delta[:amount].round(2)

puts "#{symbol} PLN #{total} (#{amount}) | color=#{color}"

puts "---"

values.each do |value|
  puts "#{value[:key]} #{value[:value]}"
end




# Reposnse
# {"status"=>"Ok",
#  "items"=>{
#    "LTC-USD"=> {
#      "market"=>{
#        "code"=>"LTC-USD",
#        "first"=>{"currency"=>"LTC", "minOffer"=>"0.0025", "scale"=>8},
#        "second"=>{"currency"=>"USD", "minOffer"=>"0.1", "scale"=>2}},
#      "time"=>"1517300225156",
#      "highestBid"=>"181.06",
#      "lowestAsk"=>"188",
#      "rate"=>"187.97",
#      "previousRate"=>"181.06"
#    },
#    "DASH-PLN"=>{"market"=>{"code"=>"DASH-PLN", "first"=>{"currency"=>"DASH", "minOffer"=>"0.00045", "scale"=>8}, "second"=>{"currency"=>"PLN", "minOffer"=>"0.1", "scale"=>2}}, "time"=>"1517300251296", "highestBid"=>"2501.08", "lowestAsk"=>"2544.6", "rate"=>"2520", "previousRate"=>"2510.02"},
#    "BTC-USD"=>{"market"=>{"code"=>"BTC-USD", "first"=>{"currency"=>"BTC", "minOffer"=>"0.00003", "scale"=>8}, "second"=>{"currency"=>"USD", "minOffer"=>"0.1", "scale"=>2}}, "time"=>"1517299384007", "highestBid"=>"11051", "lowestAsk"=>"11201.49", "rate"=>"11050.1", "previousRate"=>"11190"},
#    "BTC-EUR"=>{"market"=>{"code"=>"BTC-EUR", "first"=>{"currency"=>"BTC", "minOffer"=>"0.00003", "scale"=>8}, "second"=>{"currency"=>"EUR", "minOffer"=>"0.1", "scale"=>2}}, "time"=>"1517300262754", "highestBid"=>"8890.92", "lowestAsk"=>"9078.95", "rate"=>"8921.9", "previousRate"=>"9072.7"},
#    "LSK-BTC"=>{"market"=>{"code"=>"LSK-BTC", "first"=>{"currency"=>"LSK", "minOffer"=>"0.025", "scale"=>8}, "second"=>{"currency"=>"BTC", "minOffer"=>"0.00003", "scale"=>8}}, "time"=>"1517299271616", "highestBid"=>"0.002065", "lowestAsk"=>"0.00207517", "rate"=>"0.0020241", "previousRate"=>"0.00204455"},
#    "BTG-BTC"=>{"market"=>{"code"=>"BTG-BTC", "first"=>{"currency"=>"BTG", "minOffer"=>"0.00045", "scale"=>8}, "second"=>{"currency"=>"BTC", "minOffer"=>"0.00003", "scale"=>8}}, "time"=>"1517300239808", "highestBid"=>"0.0155", "lowestAsk"=>"0.017027", "rate"=>"0.01525524", "previousRate"=>"0.01692346"},
#    "ETH-BTC"=>{"market"=>{"code"=>"ETH-BTC", "first"=>{"currency"=>"ETH", "minOffer"=>"0.00045", "scale"=>8}, "second"=>{"currency"=>"BTC", "minOffer"=>"0.00003", "scale"=>8}}, "time"=>"1517300110877", "highestBid"=>"0.10573383", "lowestAsk"=>"0.10605959", "rate"=>"0.10468696", "previousRate"=>"0.104333"},
#    "BTG-PLN"=>{"market"=>{"code"=>"BTG-PLN", "first"=>{"currency"=>"BTG", "minOffer"=>"0.00045", "scale"=>8}, "second"=>{"currency"=>"PLN", "minOffer"=>"0.1", "scale"=>2}}, "time"=>"1517300212625", "highestBid"=>"601.01", "lowestAsk"=>"613.99", "rate"=>"602.15", "previousRate"=>"601.15"},
#    "BCC-BTC"=>{"market"=>{"code"=>"BCC-BTC", "first"=>{"currency"=>"BCC", "minOffer"=>"0.00035", "scale"=>8}, "second"=>{"currency"=>"BTC", "minOffer"=>"0.00003", "scale"=>8}}, "time"=>"1517300249216", "highestBid"=>"0.14540002", "lowestAsk"=>"0.1492295", "rate"=>"0.14922989", "previousRate"=>"0.14923042"},
#    "ETH-EUR"=>{"market"=>{"code"=>"ETH-EUR", "first"=>{"currency"=>"ETH", "minOffer"=>"0.00045", "scale"=>8}, "second"=>{"currency"=>"EUR", "minOffer"=>"0.1", "scale"=>2}}, "time"=>"1517299928722", "highestBid"=>"950.3", "lowestAsk"=>"955", "rate"=>"950.3", "previousRate"=>"950.28"},
# ...

# puts ticker
