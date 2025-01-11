class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  # Find or create stock by ticker
  def self.find_or_create_by_ticker(ticker_symbol)
    # Search for the stock in the database
    stock = find_by(ticker: ticker_symbol)
    return stock if stock

    # If not found, fetch data from the API
    stock_data = fetch_stock_from_api(ticker_symbol)
    return nil unless stock_data # Return nil if API fails

    # Create and save the stock to the database
    create!(
      ticker: stock_data[:ticker],
      name: stock_data[:name],
      last_price: stock_data[:last_price]
    )
  end

  # Fetch stock details from the Alpha Vantage API
  def self.fetch_stock_from_api(ticker_symbol)
    api_key = Rails.application.credentials.alphavantage[:api_key]
    url = "https://www.alphavantage.co/query"

    response = HTTParty.get(url, query: {
      function: 'TIME_SERIES_DAILY',
      symbol: ticker_symbol,
      apikey: api_key
    })

    # Debugging API response
    Rails.logger.debug "Alpha Vantage API Response: #{response.body}"

    # Validate response
    return nil unless response.success? && response.parsed_response['Time Series (Daily)']

    # Parse stock data
    parse_stock_data(response.parsed_response, ticker_symbol)
  end

  # Parse the stock price and name data from the API
  def self.parse_stock_data(api_response, ticker_symbol)
    # Extract time series and meta data
    time_series = api_response['Time Series (Daily)']
    meta_data = api_response['Meta Data']

    latest_date = time_series.keys.max
    latest_price = time_series[latest_date]['4. close']

    {
      ticker: meta_data['2. Symbol'],
      name: meta_data['2. Symbol'], # Placeholder for name
      last_price: latest_price.to_f
    }
  rescue StandardError => e
    Rails.logger.error "Error parsing stock data: #{e.message}"
    nil
  end
end
