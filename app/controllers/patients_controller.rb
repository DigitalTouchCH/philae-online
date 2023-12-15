class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  skip_forgery_protection only: [:search_users]


  def index
    if params[:search].present?
      # Utilisez 'ILIKE' pour une recherche insensible à la casse dans PostgreSQL
      search_query = "%#{params[:search]}%"
      @patients = policy_scope(Patient)
                   .where("first_name ILIKE ? OR last_name ILIKE ?", search_query, search_query)
                   .order(:last_name, :first_name)
    else
      @patients = policy_scope(Patient).order(:last_name, :first_name)
    end
  end

  def show
    @patient = Patient.includes(:users).find(params[:id])
    @users = @patient.users  # Assurez-vous que les utilisateurs associés sont chargés
    @ordonnances = @patient.ordonnances
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
      redirect_to patient_path(@patient), notice: "Mise à jour du patient effectué"
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
    redirect_to patients_url, alert: 'Patient non trouvé.'
  end

  def patient_params
    params.require(:patient).permit(
      :first_name,
      :last_name,
      :date_of_birth,
      :address,
      :tel1,
      :tel2,
      :contact_name,
      :contact_info,
      :contact_tel,
      :commentaire,
      :medical_history,
      :consent_form,
      :emergency_contact_name,
      :emergency_contact_tel,
      :discharge,
      :privacy_acknowledgement,
      :user_ids => [],
    )
  end

end
