#!/usr/bin/env ruby
# <bitbar.title>Spekulant Bar 2.0</bitbar.title>
# <bitbar.version>v2.0</bitbar.version>
# <bitbar.dependencies>ruby</bitbar.dependencies>
# <bitbar.author>Pawel Piotrowicz</bitbar.author>
# <bitbar.author.github>ppiotrowicz</bitbar.author.github>
# <bitbar.desc>Shows current value of bitbay wallet</bitbar.desc>

require 'open-uri'
require 'json'

Value = Struct.new(:price, :time)

class Ticker
  URL = 'https://kantor.aliorbank.pl/chart/USD/json'

  def fetch
    data = open(URL) { |f| f.read }
    @json = JSON.parse(data)
  rescue SocketError
    nil
  end

  def current
    Value.new(json['actualBuyRate'], Time.now)
  end

  def history
    json['history'].map do |v|
      timestamp = v['d']
      rate = v['r']

      Value.new(rate / 10000.00, Time.at(timestamp))
    end
  end

  private

  attr_reader :json
end

class Formatter
  DEFAULT_OPTIONS = {
    font: 'InputMonoCondensed',
    color: 'White',
    size: '12',
  }

  def self.print(text, options = {})
    puts "#{text} | #{format_options(options)}"
  end

  def self.separator
    puts '---'
  end

  def self.format_options(options)
    opts = DEFAULT_OPTIONS.merge(options)
    opts.map { |k, v| "#{k}=#{v}" }.join(' ')
  end
end

ticker = Ticker.new
ticker.fetch

Formatter.print("$ #{ticker.current.price}")
# Formatter.separator
# ticker.history.reverse.each do |value|
#   Formatter.print("#{value.price.to_s.ljust(6, '0')}   #{value.time.strftime('%H:%M')}")
# end

# puts "#{currencies['lastUpdate']}"
