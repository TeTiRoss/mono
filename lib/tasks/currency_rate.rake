# frozen_string_literal: true

namespace :currency_rate do
  task collect: :environment do
    CurrencyRatesFetchWorker.new.perform
  end
end
