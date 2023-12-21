class TimeSlotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_therapist_and_service, only: :index
  skip_after_action :verify_authorized, only: [:index]
  skip_after_action :verify_policy_scoped, only: [:index]


  def index

    all_week_availabilities = @therapist.week_availabilities

    time_slots = @therapist.available_time_slots(@service.id, @service.duration_per_unit,all_week_availabilities)

    respond_to do |format|
      format.json { render json: time_slots }
    end
  end

  private

  def set_therapist_and_service
    @therapist = Therapist.find(params[:therapist_id])
    @service = Service.find(params[:service_id])
  end


end
