class Monobank
  include HTTParty

  base_uri Rails.application.credentials[:base_url]

  def initialize
    @options = { headers: { 'X-Token' => Rails.application.credentials[:api_key] } }
  end

  def currency_rates
    self.class.get('/bank/currency', @options)
  end

  def profile
    self.class.get('/personal/client-info', @options)
  end

  def statement account: Rails.application.credentials[:base_account_id], from:, to: Time.current
    from = from.to_i
    to   = to.to_i

    retries = 0
    max_retries = 5
    loop do
      response = self.class.get("/personal/statement/#{account}/#{from}/#{to}", @options)

      if !response.success? && response['errorDescription'] && response['errorDescription'] == 'Too many requests'
        puts 'sleep time'
        raise 'Retry limit reached' if retries >= max_retries
        retries += 1

        sleep(30)
      else
        return response
      end
    end
  end
end
