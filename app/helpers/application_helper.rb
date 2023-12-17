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


  def status_update_form_for_event_individuel(event)
    form_with url: update_status_event_individuel_path(event), method: :patch, local: true do |f|
      concat(
        content_tag(:span, class: "badge rounded-pill #{status_class(event.status)}") do
          f.select :status, EventIndividuel.statuses.map { |status| [status, status] },
          { selected: event.status },
          name: 'event_individuel[status]',
          class: "form-select badge-status-dropdown",
          onchange: 'this.form.submit()'
        end
      )
      concat f.submit 'Update', style: 'display: none;'
    end
  end

  def status_class(status)
    # Retourne une classe CSS en fonction du statut
    case status
    when "à confirmer"
      "status-pending"
    when "confirmé"
      "status-confirmed"
    when "réalisé"
      "status-done"
    when "non excusé"
      "status-non-excused"
    when "excusé"
      "status-excused"
    else
      "status-pending"
    end
  end

  def ordonnance_association_form_for_event_individuel(event, ordonnances)
    form_with url: associate_ordonnance_event_individuel_path(event), method: :patch, local: true do |f|
      concat(
        content_tag(:span, class: "badge rounded-pill #{ordonnance_badge_class(event.ordonnance_id)}") do
          f.select :ordonnance_id, options_from_collection_for_select(ordonnances, :id, :title, event.ordonnance_id), {}, { class: "form-select badge-status-dropdown", onchange: 'this.form.submit()' }
        end
      )
      concat f.submit 'Associate', style: 'display: none;'
    end
  end

  def ordonnance_badge_class(ordonnance_id)
    ordonnance_id.nil? ? 'status-non-excused' : 'status-excused'
  end



end
