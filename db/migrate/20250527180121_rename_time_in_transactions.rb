class RenameTimeInTransactions < ActiveRecord::Migration[8.0]
  def change
    rename_column :transactions, :time, :time_int
  end
end
