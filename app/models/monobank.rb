class Monobank
  include HTTParty

  base_uri Rails.application.credentials[:base_url]

  def initialize
    @options = { headers: { 'X-Token' => Rails.application.credentials[:api_key] } }
  end

  def currency
    self.class.get('/bank/currency', @options)
  end

  def profile
    self.class.get('/personal/client-info', @options)
  end

  def statement account:, from:, to: Time.current
    from = from.to_i
    to   = to.to_i

    self.class.get("/personal/statement/#{account}/#{from}/#{to}", @options)
  end
end
