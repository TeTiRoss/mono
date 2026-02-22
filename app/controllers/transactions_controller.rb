class TransactionsController < ApplicationController
  def index
    transactions = Transaction.all
    transactions = transactions.where("description ILIKE :q", q: "%#{params[:query]}%") if params[:query].present?
    transactions = transactions.where(mcc: params[:mcc]) if params[:mcc].present?
    transactions = apply_date_filter(transactions)
    transactions = apply_sorting(transactions)

    @total_spent  = transactions.where('amount < 0').sum(:amount) * -1
    @total_income = transactions.where('amount > 0').sum(:amount)
    @pagy, @transactions = pagy(transactions)
  end

  def sync
    from_time, to_time = parse_sync_period(params[:from_date], params[:to_date])

    unless from_time && to_time
      return redirect_to transactions_path, alert: 'Please provide a valid From and To date'
    end

    if from_time > to_time
      return redirect_to transactions_path, alert: 'From date must be before To date'
    end

    TransactionsFetchWorker.new.perform from_time, to_time

    redirect_to transactions_path, notice: "Transactions were synced for #{from_time.to_date}..#{to_time.to_date}"
  end

  private

  def apply_date_filter(transactions)
    from_time, to_time = parse_date_range(params[:filter_from_date], params[:filter_to_date])

    transactions = transactions.where('time_int >= ?', from_time.to_i) if from_time
    transactions = transactions.where('time_int <= ?', to_time.to_i) if to_time
    transactions
  end

  def apply_sorting(transactions)
    prepare_sorting_state

    sort_key = @sort_key
    direction = @sort_direction

    case sort_key
    when 'amount'
      transactions.order(amount: direction, time_int: :desc)
    when 'time'
      transactions.order(time_int: direction)
    else
      transactions.order(time_int: :desc)
    end
  end

  def prepare_sorting_state
    @sort_key = params[:sort]
    @sort_direction = params[:direction] == 'asc' ? :asc : :desc

    current_direction = @sort_direction == :asc ? 'asc' : 'desc'
    base_query = request.query_parameters.except('page')

    time_sort_active = @sort_key == 'time' || @sort_key.blank?
    effective_time_direction = @sort_key == 'time' ? current_direction : 'desc'
    next_time_direction = time_sort_active && effective_time_direction == 'asc' ? 'desc' : 'asc'
    @time_sort_label = "Time#{time_sort_active ? " #{effective_time_direction == 'asc' ? '↑' : '↓'}" : ''}"
    @time_sort_params = base_query.merge(sort: 'time', direction: next_time_direction)

    amount_sort_active = @sort_key == 'amount'
    effective_amount_direction = amount_sort_active ? current_direction : 'desc'
    next_amount_direction = amount_sort_active && effective_amount_direction == 'asc' ? 'desc' : 'asc'
    @amount_sort_label = "Amount#{amount_sort_active ? " #{effective_amount_direction == 'asc' ? '↑' : '↓'}" : ''}"
    @amount_sort_params = base_query.merge(sort: 'amount', direction: next_amount_direction)
  end

  def parse_sync_period(from_date, to_date)
    from_value = from_date.presence || 1.week.ago.to_date.iso8601
    to_value   = to_date.presence || Date.current.iso8601

    parse_date_range(from_value, to_value)
  end

  def parse_date_range(from_date, to_date)
    from_time = Date.iso8601(from_date).in_time_zone.beginning_of_day if from_date.present?
    to_time   = Date.iso8601(to_date).in_time_zone.end_of_day if to_date.present?
    [from_time, to_time]
  rescue ArgumentError, TypeError
    [nil, nil]
  end
end
