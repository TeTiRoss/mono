class AddRawDataFieldsToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :mcc, :integer
    add_column :transactions, :original_mcc, :integer
    add_column :transactions, :currency_code, :integer
  end
end
