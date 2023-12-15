module ApplicationHelper

  def calculer_age(date_naissance)
    return unless date_naissance
    ((Time.zone.now - date_naissance.to_time) / 1.year.seconds).floor
  end

  TOTAL_HOURS = 18.0

  def height_percentage(start_time, end_time)
    hours = (end_time - start_time).seconds.to_i / 3600.0
    (hours / TOTAL_HOURS) * 100
  end

  def top_position(start_time)
    start_hours_from_5_am = (start_time.seconds_since_midnight / 3600.0) - 5.0
    start_hours_from_5_am = 0 if start_hours_from_5_am < 0
    (start_hours_from_5_am / TOTAL_HOURS) * 100
  end

end
