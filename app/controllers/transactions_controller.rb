class TransactionsController < ApplicationController
  def index
    transactions = Transaction.order(time_int: :desc)
    transactions = transactions.where("description ILIKE :q", q: "%#{params[:query]}%") if params[:query].present?

    @total_spent  = transactions.where('amount < 0').sum(:amount) * -1
    @total_income = transactions.where('amount > 0').sum(:amount)
    @pagy, @transactions = pagy(transactions)
  end

  def sync
    TransactionsFetchWorker.new.perform 1.week.ago, Time.current

    redirect_to transactions_path, notice: 'Transactions were sync for the week period'
  end
end
