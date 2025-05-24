class TransactionsController < ApplicationController
  def index
  	@transactions = Transaction.first(100)
  end
end
