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
        id: event.id,
        eventType: 'personal',
        title: 'Personal Event',
        start: event.start_date_time.iso8601,
        end: event.end_date_time.iso8601,
        reason: event.reason,
        color: '#D3D3D3',
        # Autres propriétés d'événement personnalisées
      }
    end

    @group_events = @therapist.event_groupes.map do |event|
      {
        id: event.id,
        eventType: 'group',
        title: 'Group Event',
        start: event.start_date_time.iso8601,
        end: event.end_date_time.iso8601
        # Autres propriétés d'événement de groupe
      }
    end

    @individual_events = @therapist.event_individuels.map do |event|
      {
        id: event.id,
        eventType: 'individual',
        title: 'Individual Event',
        start: event.start_date_time.iso8601,
        end: event.end_date_time.iso8601,
        color: event.service.color,
        patient: event.patient.first_name + ' ' + event.patient.last_name,
        # Autres propriétés d'événement individuel
      }
    end

    @all_events = @personal_events + @group_events + @individual_events

    render json: @all_events.to_json
  end

  def update_event
    @therapist = Therapist.find(params[:id])
    authorize @therapist

    event_id = params[:event_id]
    event_type = params[:event_type]

    case event_type
      when 'personal'
        event = @therapist.event_personels.find_by(id: event_id)
      when 'group'
        event = @therapist.event_groupes.find_by(id: event_id)
      when 'individual'
        event = @therapist.event_individuels.find_by(id: event_id)
      else
        event = nil
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
