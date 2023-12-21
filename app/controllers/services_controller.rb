class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    if params[:therapist_id]
      # Find the therapist using the provided ID
      therapist = Therapist.find(params[:therapist_id])
      # Scope services to the specific therapist using the join table
      @services = policy_scope(therapist.services)
    else
      # Otherwise, retrieve all services scoped to the current policy
      @services = policy_scope(Service).order(:name)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @services }
    end
  end


  def show
    authorize @service
  end

  def new
    @service = Service.new
    authorize @service
  end

  def create
    @service = Service.new(service_params)
    authorize @service

    if @service.save
      redirect_to services_path, notice: 'Service was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize @service
  end

  def update
    authorize @service
    if @service.update(service_params)
      redirect_to services_path, notice: 'Service was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @service
    if @service.destroy
      redirect_to services_url, notice: 'Service was successfully destroyed.'
    else
      redirect_to services_url, alert: 'Service could not be destroyed. Please make sure all dependencies are removed.'
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to services_url, alert: 'Service not found.'
  end

  def service_params
    params.require(:service).permit(:name, :duration_per_unit, :color, :active, :is_group, :name_short, therapist_ids: [])
  end
end
