class CurrencyRatesFetchWorker
  include Sidekiq::Worker

  def perform
  	response = Monobank.new.currency_rates

  	raise 'Invalid response' unless response.success?

  	response.each do |currency_rate|
      find_params = { date_int: currency_rate['date'], iso_nummeric_from: currency_rate['currencyCodeA'],
                      iso_nummeric_to: currency_rate['currencyCodeB'] }

  		CurrencyRate.find_or_initialize_by(find_params) do |new_currency_rate|
  			new_currency_rate.raw_data = currency_rate
        new_currency_rate.assign_attributes \
          rate_buy: currency_rate['rateBuy'],
          rate_sell: currency_rate['rateSell'],
          rate_cross: currency_rate['rateCross']

  			new_currency_rate.save!
  		end
  	end
  end
end
