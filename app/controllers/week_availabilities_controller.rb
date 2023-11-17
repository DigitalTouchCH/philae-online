class WeekAvailabilitiesController < ApplicationController

  before_action :authenticate_user!

  def index
    @week_availabilities = policy_scope(WeekAvailability)
  end

  def new
    @week_availability = WeekAvailability.new
    authorize @week_availability
  end

  def show
    @week_availability = WeekAvailability.find(params[:id])
    authorize @week_availability
    redirect_to week_availabilities_path
  end

  def create
    @week_availability = WeekAvailability.new(week_availability_params)
    @week_availability.therapist = current_user.therapist
    authorize @week_availability

    if @week_availability.save
      redirect_to week_availabilities_path, notice: 'Week Availability was successfully created.'
    else
      flash[:alert] = @week_availability.errors.full_messages.join(", ")
      redirect_to week_availabilities_path
    end
  end

  def destroy
    @week_availability = WeekAvailability.find(params[:id])
    authorize @week_availability
    @week_availability.destroy
    redirect_to week_availabilities_path, notice: 'Week Availability was successfully deleted.', status: :found
  end

  def edit
    @week_availability = WeekAvailability.find(params[:id])
    authorize @week_availability
  end

  def update
    @week_availability = WeekAvailability.find(params[:id])
    authorize @week_availability

    if @week_availability.update(week_availability_params)
      redirect_to week_availabilities_path, notice: 'Week Availability was successfully updated.'
    else
      flash[:alert] = @week_availability.errors.full_messages.join(", ")
      redirect_to week_availabilities_path
    end
  end

  private

  def week_availability_params
    params.require(:week_availability).permit(:valid_from, :valid_until, :name)
  end

end