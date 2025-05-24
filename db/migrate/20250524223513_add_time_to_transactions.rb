class AddTimeToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :time, :integer
  end
end
