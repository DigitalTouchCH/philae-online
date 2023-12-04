class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @patients = policy_scope(Patient).order(:last_name, :first_name)
  end

  def show
    authorize @patient
  end

  def new
    @patient = Patient.new
    authorize @patient
  end

  def create
    @patient = Patient.new(patient_params)
    authorize @patient
    if @patient.save
      redirect_to patients_path, notice: 'Patient was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize @patient
  end

  def update
    authorize @patient
    if @patient.update(patient_params)
      redirect_to patient_path(@patient), notice: 'Patient was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @patient
    if @patient.destroy
      redirect_to patients_url, notice: 'Patient was successfully destroyed.'
    else
      redirect_to patients_url, alert: 'Patient could not be destroyed. Please make sure all dependencies are removed.'
    end
  end

  def events
    @patient = Patient.find(params[:id])
    @events = @patient.sessions # Assurez-vous que cela renvoie les données sous un format compatible avec FullCalendar

    render json: @events.map { |event| { title: event.title, start: event.start_time, end: event.end_time } }
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to patients_url, alert: 'Patient not found.'
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :date_of_birth, :address, :tel1, :tel2, :contact_name, :contact_info, :contact_tel, :commentaire)
  end
end
