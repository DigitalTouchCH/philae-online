class TherapistsController < ApplicationController
  def show
    @therapist = Therapist.find(params[:id])
    authorize @therapist
  end

  def all_events
    @therapist = Therapist.find(params[:id])
    authorize @therapist
    @personal_events = @therapist.event_personels.map do |event|
      {
        title: 'Personal Event',
        start: event.start_date_time.iso8601,
        end: event.end_date_time.iso8601,
        reason: event.reason,
        color: '#D3D3D3'
        # Autres propriétés d'événement personnalisées (ne pas utiliser les commentaires JavaScript ici)
      }
    end

    @group_events = @therapist.event_groupes.map do |event|
      {
        title: 'Group Event',
        start: event.start_date_time.iso8601,
        end: event.end_date_time.iso8601
        # Autres propriétés d'événement de groupe (ne pas utiliser les commentaires JavaScript ici)
      }
    end

    @individual_events = @therapist.event_individuels.map do |event|
      {
        title: 'Individual Event',
        start: event.start_date_time.iso8601,
        end: event.end_date_time.iso8601,
        color: event.service.color
        # Autres propriétés d'événement individuel (ne pas utiliser les commentaires JavaScript ici)
      }
    end

    @all_events = @personal_events + @group_events + @individual_events

    render json: @all_events.to_json
  end

  def update_event
    # Vous devez déterminer comment vous savez quel événement mettre à jour.
    # Cela pourrait être via des paramètres transmis lors de l'événement drop.
    # Par exemple, vous pourriez avoir un paramètre :event_id et :event_type
    event_type = params[:event_type]
    event = case event_type
            when 'personal'
              @therapist.event_personels.find(params[:event_id])
            when 'group'
              @therapist.event_groupes.find(params[:event_id])
            when 'individual'
              @therapist.event_individuels.find(params[:event_id])
            else
              nil
            end

    if event
      start_time = Time.zone.parse(params[:start])
      end_time = Time.zone.parse(params[:end])

      if event.update(start_date_time: start_time, end_date_time: end_time)
        render json: { success: true }
      else
        render json: { success: false, errors: event.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: 'Event not found' }, status: :not_found
    end
  end

end
