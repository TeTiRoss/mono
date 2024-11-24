class TransactionsFetchWorker
  include Sidekiq::Worker

  def perform(time_from)
		time_from ||= 1.day.ago

  	response = Monobank.new.statement(from: time_from)

  	raise 'Invalid response' unless response.success?

  	response.each do |transaction|
  		Transaction.find_or_initialize_by(mono_id: transaction['id']) do |new_transcation|
  			new_transcation.raw_data = transaction
  			new_transcation.save!
  		end
  	end
  end
end
