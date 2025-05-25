class TransactionsController < ApplicationController
  def index
    @pagy, @transactions = pagy(Transaction.order(time: :desc))
  end
end
