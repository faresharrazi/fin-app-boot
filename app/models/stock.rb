class Stock < ApplicationRecord
    def self.new_lookup(ticker_symbol)
        api_key = Rails.application.credentials.finazon[:api_key]
        url = "https://api.finazon.io/latest/finazon/us_stocks_essential/price"
        
        response = HTTParty.get(url, query: { apikey: api_key, ticker: ticker_symbol })
        # puts "Response Body: #{response.body}" # Debug: Print raw response
        # puts "Parsed Response: #{response.parsed_response}" # Debug: Print parsed response
      
        # Check if the response contains the price
        if response.success? && response.parsed_response['p']
          response.parsed_response['p']
        else
          raise "Stock price not found for ticker: #{ticker_symbol}"
        end
      rescue StandardError => e
        "Error fetching stock price: #{e.message}"
      end      
end
