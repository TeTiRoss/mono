class CurrencyRatesController < ApplicationController
  def index
  	@currency_rates = currency_rates
  end

  private

  def currency_rates
    currency_rates_response.success? ? currency_rates_response : []
  end

  def currency_rates_response
    @currency_rates_response ||= Monobank.new.currency_rates
  end
end
