require 'open-uri'
require 'json'

class Ticker
  URL = 'https://api.bitbay.net/rest/trading/ticker'

  def fetch
    data = open(URL) { |f| f.read }
    ticker = JSON.parse(data)
    items = ticker['items']
    items.merge(fiat_currencies)
  rescue SocketError
    nil
  end

  private

  def fiat_currencies
    {
      'PLN-PLN' => {
        'rate' => 1 ,
        'previousRate' => 1,
        'time' => Time.now.utc.to_i * 1000
      }
    }
  end
end
