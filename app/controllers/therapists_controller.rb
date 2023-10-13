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
        reason: event.reason
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
        end: event.end_date_time.iso8601
        # Autres propriétés d'événement individuel (ne pas utiliser les commentaires JavaScript ici)
      }
    end

    @all_events = @personal_events + @group_events + @individual_events

    render json: @all_events.to_json
  end
end
