class DataStorer
  def initialize(username:, permission_type:, dates:)
    @username        = username
    @permission_type = permission_type
    @dates           = dates.map do |date|
      date.strftime('%m/%d/%Y')
    end
  end

  def run
    airtable_app_url = "https://api.airtable.com/v0/#{ENV['AIRTABLE_APP_KEY']}"

    dates.each do |date|
      data = {
        'fields': {
          'Username': username,
          'Type': permission_type,
          'Date': date
        }
      }.to_json

      connection = Faraday.new(url: airtable_app_url + "/Leaves") do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      connection.authorization(:Bearer, ENV['AIRTABLE_API_KEY'])

      connection.post do |req|
        req.headers['Content-Type'] = 'application/json'

        req.body = data
      end
    end
  end

  private

  attr_reader :username, :permission_type, :dates
end
