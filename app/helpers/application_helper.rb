module ApplicationHelper
	include Pagy::Frontend

	def currency_name(currency_code)
		currency = Money::Currency.find_by_iso_numeric(currency_code)
		"#{currency.name} (#{currency.iso_code})"
	end

	def currency_date(date_int)
		Time.zone.at(date_int)
	end
end
