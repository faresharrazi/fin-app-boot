class StocksController < ApplicationController
  def search_stock
    if params[:ticker_symbol].present?
      @stock = Stock.find_or_create_by_ticker(params[:ticker_symbol])

      if @stock
        if current_user.stocks.include?(@stock)
          @alert_message = "#{@stock.ticker} is already in your portfolio."
        end
      else
        @error_message = "Stock not found. Please check the ticker symbol."
      end
    else
      @error_message = "Please enter a valid stock ticker."
    end

    render html: "<turbo-frame id='results'>#{render_to_string(partial: 'users/results', locals: { stock: @stock, error_message: @error_message, alert_message: @alert_message })}</turbo-frame>".html_safe
  end
end
