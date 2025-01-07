class RenameTicketToTickerInStock < ActiveRecord::Migration[8.0]
  def change
    rename_column :stocks, :ticket, :ticker
  end
end
