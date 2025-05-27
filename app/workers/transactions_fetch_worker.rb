class TransactionsFetchWorker
  include Sidekiq::Worker

  def perform(time_from, time_to)
		time_from ||= 1.day.ago
		time_to   ||= Time.current

  	response = StatementHandler.new.get_statements from: time_from, to: time_to

  	response.each_slice(1_000) do |slice|
			slice.each do |transaction|
				Transaction.find_or_initialize_by(mono_id: transaction['id']) do |new_transcation|
					new_transcation.raw_data = transaction
					new_transcation.time_int = transaction['time']
					new_transcation.description = transaction['description']
					new_transcation.amount = transaction['amount']
					new_transcation.mcc = transaction['mcc']
					new_transcation.original_mcc = transaction['original_mcc']
					new_transcation.currency_code = transaction['currency_code']
					new_transcation.save!
				end
			end
  	end
  end
end
