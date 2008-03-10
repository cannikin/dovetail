# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def class_if_current(class_name='active',values={})
    current = values.keys.all? do |key|
      (params[key] && params[key] == values[key]) || (values[key] == nil && !params.has_key?(key))
    end
    if current
      'class="' + class_name.to_s + '"'
    end
  end

  def distance_of_time_in_words(from_time, to_time = Time.now, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round

    case distance_in_minutes
      when 0..1           then (distance_in_minutes==0) ? 'a few seconds ago' : '1 minute ago'
      when 2..59          then "#{distance_in_minutes} minutes ago"
      when 60..90         then "1 hour ago"
      when 90..1440       then "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      when 1440..2160     then '1 day ago' # 1 day to 1.5 days
      when 2160..2880     then "#{(distance_in_minutes.to_f / 1440.0).round} days ago" # 1.5 days to 2 days
      else from_time.strftime("%B") + ' ' + from_time.strftime("%d").to_i.ordinalize + ' at ' + from_time.strftime("%l:%M") + from_time.strftime('%p').downcase
    end

  end

end
