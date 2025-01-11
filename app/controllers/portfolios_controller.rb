class PortfoliosController < ApplicationController
  before_action :authenticate_user!

  def create
    stock = Stock.find(params[:stock_id])
    if current_user.stocks.include?(stock)
      flash[:alert] = "#{stock.ticker} is already in your portfolio."
    else
      current_user.stocks << stock
      flash[:notice] = "#{stock.ticker} was successfully added to your portfolio."
    end
    redirect_to my_portfolio_path
  end

  def destroy
    stock = current_user.stocks.find(params[:id])
    current_user.stocks.delete(stock)
    flash[:notice] = "#{stock.ticker} was removed from your portfolio."
    redirect_to my_portfolio_path
  end
end
