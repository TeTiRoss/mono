class TransactionsController < ApplicationController
  def index
  	@transactions = Transaction.order(time: :desc).first(50)
  end
end
