class AddMonoIdUniquenessConstraintToTransactions < ActiveRecord::Migration[6.0]
  def change
  	add_index :transactions, :mono_id, unique: true
  end
end
