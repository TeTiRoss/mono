class TransactionsFetchWorker
  include Sidekiq::Worker

  def perform
  	response = Monobank.new.statement(from: 1.day.ago)

  	raise 'Invalid response' unless response.success?

  	response.each do |transaction|
  		Transaction.find_or_initialize_by(mono_id: transaction['id']) do |new_transcation|
  			new_transcation.raw_data = transaction
  			new_transcation.save!
  		end
  	end
  end
end