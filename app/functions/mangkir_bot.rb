require 'telegram/bot'
require 'faraday'

token = ENV['TELEGRAM_BOT_API_TOKEN']
AIRTABLE_APP_URL = "https://api.airtable.com/v0/#{ENV['AIRTABLE_APP_KEY']}"

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/save'
      first_name  = message.from.first_name
      last_name   = message.from.last_name
      full_name   = first_name + ' ' + last_name

      bot.api.send_message(chat_id: message.chat.id, text: "#{full_name} takes annual leave for 1 day")

      data = {
        'fields': {
          'Username': 'test_from_ruby'
        }
      }.to_json

      connection = Faraday.new(url: AIRTABLE_APP_URL + "/Leaves") do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      @connection.authorization(:Bearer, ENV['AIRTABLE_API_KEY'])

      connection.post do |req|
        req.headers['content-type'] = 'application/json'

        req.body = data
      end
    end
  end
end
