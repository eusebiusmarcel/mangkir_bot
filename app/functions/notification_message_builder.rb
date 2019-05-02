class NotificationMessageBuilder
  def initialize(full_name:, permission_type:, dates:)
    @full_name       = full_name
    @permission_type = permission_type
    @dates           = dates.map do |date|
      date.strftime('%-d %B %Y')
    end
  end

  def call
    "#{full_name} takes #{permission_type} #{activity} " \
    "for #{dates.count} #{time_period}, " \
    "on #{dates.join(', ')}"
  end

  private

  attr_reader :full_name, :permission_type, :dates

  def activity
    if permission_type == 'remote'
      'work'
    else
      'leave'
    end
  end

  def time_period
    if dates.count == 1
      'day'
    else
      'days'
    end
  end
end
