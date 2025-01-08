class UsersController < ApplicationController
  def my_portfolio
      if params[:ticker_symbol].present?
        begin
          @stock_price = Stock.new_lookup(params[:ticker_symbol])
        rescue => e
          @stock_price = e.message # Assign the error message to @stock_price
        end
      end
    end
 
end
