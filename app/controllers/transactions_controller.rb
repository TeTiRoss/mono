class TransactionsController < ApplicationController
  def index
  	@transactions = Transaction.last(50)
  end
end
