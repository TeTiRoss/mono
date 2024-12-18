class StatementHandler
  def get_statements(account: Rails.application.credentials[:base_account_id], from:, to: Time.current)
    statements = fetch_by_time(from: from, to: to)

    statements.flatten
  end

  private

  def fetch_by_time(from:, to:)
    date_range = (to.to_date - from.to_date).to_i

    statements = []

    if date_range >= 31
      puts 'inside #fetch_by_time loop'
      new_to = from + 31.days
      # refactor candidate --
      statements << fetch_statements_by_count(from: from, to: new_to)
      statements << fetch_by_time(from: new_to, to: to)
      # refactor candidate --
    else
      statements << fetch_statements_by_count(from: from, to: to)
    end

    statements
  end

  def fetch_statements_by_count(from:, to:)
    puts "fetching statements from: #{Time.at(from).strftime('%F %T')}, to: #{Time.at(to).strftime('%F %T')}"
    statements = Monobank.new.statement(from: from, to: to).presence || []

    if statements.size == 500
      puts 'inside #fetch_statements_by_count loop'
      statements << fetch_statements_by_count(from: from, to: statements.last['time'])
    end

    statements
  end
end
