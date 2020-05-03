class CurrencyRatesController < ApplicationController
  def index
  	@currency_rates = CurrencyRateQuery.new(initial_scope: CurrencyRate.all).call
  end
end
