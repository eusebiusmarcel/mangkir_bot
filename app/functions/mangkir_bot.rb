require 'dotenv/load'
require 'telegram/bot'
require 'faraday'
require 'byebug'
require_relative 'notification_message_builder'
require_relative 'data_storer'

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_API_TOKEN']) do |bot|
  bot.listen do |message|
    command = message.text.split
    case command.shift
    when '/save'
      permission_type = command.shift
      unless %w[annual sick remote].include?(permission_type)
        bot.api.send_message(chat_id: message.chat.id, text: 'Invalid permission type')
        next
      end

      dates = command.map do |date|
        Date.strptime(date, '%d-%m-%y')
      end

      username    = message.from.username
      first_name  = message.from.first_name
      last_name   = message.from.last_name
      full_name   = first_name + ' ' + last_name

      notification_message = NotificationMessageBuilder.new(
        full_name: full_name,
        permission_type: permission_type,
        dates: dates
      ).call

      bot.api.send_message(
        chat_id: message.chat.id,
        text: notification_message
      )

      DataStorer.new(
        username: username,
        permission_type: permission_type,
        dates: dates
      ).run
    end
  end
end
