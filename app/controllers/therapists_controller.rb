class TherapistsController < ApplicationController


  before_action :authenticate_user!
  before_action :set_therapist, only: [:show, :edit, :update, :destroy, :all_events, :update_event]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @therapists = policy_scope(Therapist).includes(:firm).order(:last_name, :first_name)
    @firms = Firm.includes(:therapists).order(:name)
    @unattached_therapists = Therapist.where(firm_id: nil).order(:last_name, :first_name)
  end

  def show
    authorize @therapist
  end

  def new
    @therapist = Therapist.new
    authorize @therapist
  end

  def create
    @therapist = Therapist.new(therapist_params)
    authorize @therapist

    if @therapist.save
      redirect_to therapists_path, notice: 'Therapist was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize @therapist
  end

  def update
    authorize @therapist
    if @therapist.update(therapist_params)
      redirect_to therapists_path, notice: 'Therapist was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @therapist
    if @therapist.destroy
      redirect_to therapists_url, notice: 'Therapist was successfully destroyed.'
    else
      redirect_to therapists_url, alert: 'Therapist could not be destroyed. Please make sure all dependencies are removed.'
    end
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
        end: event.end_date_time.iso8601,
        service: event.service.name_short,
        # serviceshort: event.service.short_name
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
        #extra
        patient: event.patient.last_name.upcase.slice(0, 12),
        patientfull: event.patient.first_name.capitalize + ' ' + event.patient.last_name.upcase,
        patientId: event.patient.id,
        servicename: event.service.name_short,
        ordo_event_count: event.ordonnance ? event.ordonnance.event_individuels.count.to_s : "?",
        ordo_nb_total: event.ordonnance ? event.ordonnance.num_of_session.to_s : "?"
      }
    end

    @background_event = [{
      start: '2023-11-03T10:00:00',
      end: '2023-11-03T16:00:00',
      display: 'background',
      color: '#FF0000'
    }]

    @all_events = @personal_events + @group_events + @individual_events + @background_event

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

  private

  def set_therapist
    @therapist = Therapist.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to therapists_url, alert: 'Therapist not found.'
  end

  def therapist_params
    params.require(:therapist).permit(:first_name, :last_name, :is_manager, :is_active, :user_id, :firm_id)
  end


end
