class AddMonoIdToTransactions < ActiveRecord::Migration[6.0]
  def change
  	add_column :transactions, :mono_id, :string
  end
end
