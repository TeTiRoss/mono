# frozen_string_literal: true

namespace :transaction do
  task collect: :environment do
    TransactionsFetchWorker.perform_async
  end
end
