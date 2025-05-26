class TransactionsController < ApplicationController
  def index
    @pagy, @transactions = pagy(Transaction.order(time: :desc))
  end

  def sync
    TransactionsFetchWorker.new.perform 1.week.ago, Time.current

    redirect_to transactions_path, notice: 'Transactions were sync for the week period'
  end
end
