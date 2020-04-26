class CreateCurrencyRates < ActiveRecord::Migration[6.0]
  def change
    create_table :currency_rates do |t|
    	t.jsonb   :raw_data
    	t.integer :date_int
    	t.string  :iso_nummeric_from
    	t.string  :iso_nummeric_to

    	# https://rietta.com/blog/best-data-types-for-currencymoney-in/
    	t.decimal  :rate_buy,   precision: 13, scale: 4
      t.decimal  :rate_sell,  precision: 13, scale: 4
    	t.decimal  :rate_cross, precision: 13, scale: 4


      t.timestamps
    end
  end
end
