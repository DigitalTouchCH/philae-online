# app/controllers/therapists_controller.rb

class TherapistsController < ApplicationController
  def show
    @therapist = Therapist.find(params[:id])
    authorize @therapist
  end

  def events
    @therapist = Therapist.find(params[:id])
    authorize @therapist
    @events = EventPersonel.where(therapist_id: @therapist.id)

    render json: @events.map { |event|
      {
        title: event.name,
        start: event.start_time,
        end: event.end_time
        # other event attributes...
      }
    }
  end
end
