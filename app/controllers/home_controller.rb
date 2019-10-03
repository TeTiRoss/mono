class HomeController < ApplicationController
  def index
    @currency = Monobank.new.currency
  end
end
