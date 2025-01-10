class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    api_key = Rails.application.credentials.alphavantage[:api_key]
    url = "https://www.alphavantage.co/query"
    
    response = HTTParty.get(url, query: {
      function: 'TIME_SERIES_DAILY',
      symbol: ticker_symbol,
      apikey: api_key
    })

    # Debug: Print raw response if needed
    # puts "Response Body: #{response.body}" 
    # puts "Parsed Response: #{response.parsed_response}"

    if response.success? && response.parsed_response['Time Series (Daily)']
      # Extract the latest date
      time_series = response.parsed_response['Time Series (Daily)']
      latest_date = time_series.keys.max
      latest_price = time_series[latest_date]['4. close']
      
      latest_price
    else
      raise "Stock price not found for ticker: #{ticker_symbol}"
    end
  end
end
