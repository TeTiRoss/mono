# frozen_string_literal: true

namespace :transaction do
  task collect: :environment do
    TransactionsFetchWorker.new.perform
  end
end
