class HomeController < ApplicationController
  def index
  	@currencies = currencies
  end

  private

  def currencies
  	currencies_response.success? ? currencies_response : []
  end

  def currencies_response
  	@currencies_response ||= Monobank.new.currency
  end
end
