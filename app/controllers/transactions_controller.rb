class TransactionsController < ApplicationController
  def index
    transactions = Transaction.order(time_int: :desc)
    transactions = transactions.where("description ILIKE :q", q: "%#{params[:query]}%") if params[:query].present?
    transactions = transactions.where(mcc: params[:mcc]) if params[:mcc].present?

    @total_spent  = transactions.where('amount < 0').sum(:amount) * -1
    @total_income = transactions.where('amount > 0').sum(:amount)
    @pagy, @transactions = pagy(transactions)
  end

  def sync
    from_time, to_time = parse_sync_period(params[:from_date], params[:to_date])

    if from_time > to_time
      return redirect_to transactions_path, alert: 'From date must be before To date'
    end

    TransactionsFetchWorker.new.perform from_time, to_time

    redirect_to transactions_path, notice: "Transactions were synced for #{from_time.to_date}..#{to_time.to_date}"
  end

  private

  def parse_sync_period(from_date, to_date)
    from_value = from_date.presence || 1.week.ago.to_date.iso8601
    to_value   = to_date.presence || Date.current.iso8601

    from_time = Date.iso8601(from_value).in_time_zone.beginning_of_day
    to_time   = Date.iso8601(to_value).in_time_zone.end_of_day

    [from_time, to_time]
  end
end
