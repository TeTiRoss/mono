class CurrencyRateQuery
	attr_reader :initial_scope, :params

	def initialize initial_scope:, params: {}
		@initial_scope = initial_scope
		@params        = params
	end

	def call
		initial_scope.where(created_at: CurrencyRate.select('MAX(created_at)').group('iso_nummeric_from, iso_nummeric_to'))
	end
end