class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.jsonb :raw_data

      t.timestamps
    end
  end
end
