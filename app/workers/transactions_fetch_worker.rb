class TransactionsFetchWorker
  include Sidekiq::Worker

  def perform(time_from)
		time_from ||= 1.day.ago

  	response = StatementHandler.new.get_statements from: time_from

  	response.each_slice(1_000) do |slice|
			slice.each do |transaction|
				Transaction.find_or_initialize_by(mono_id: transaction['id']) do |new_transcation|
					new_transcation.raw_data = transaction
					new_transcation.save!
				end
			end
  	end
  end
end
