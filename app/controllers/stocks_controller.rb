class StocksController < ApplicationController
    def search_stock
        if params[:ticker_symbol].present?
            begin
            @stock_price = Stock.new_lookup(params[:ticker_symbol])
            rescue => e
            @error_message = "Error: #{e.message}"
            end
        else
            @error_message = "Please enter a valid stock ticker."
        end

        render html: "<turbo-frame id='results'>#{render_to_string(partial: 'users/results', locals: { stock_price: @stock_price, error_message: @error_message })}</turbo-frame>".html_safe
    end
  end
  