class EventIndividuelsController < ApplicationController
  before_action :set_event_individuel, only: [:update_status, :associate_ordonnance]
  before_action :set_therapists, only: [:new, :create, :edit, :update]


  def new
    @event_individuel = EventIndividuel.new
    @therapists = Therapist.all
    @services = [] # Initialize @services as an empty array
    authorize @event_individuel
  end

  def create
    @event_individuel = EventIndividuel.new(event_params)
    authorize @event_individuel
    if @event_individuel.save
      redirect_to patient_path(@event_individuel.patient), notice: 'Rendez-vous créé avec succès.'
    else
      render :new
    end
  end


  def update_status
    authorize @event_individuel, :update_status?
    if @event_individuel.update(event_params)
      redirect_to patient_path(@event_individuel.patient), notice: 'Statut mis à jour avec succès.'
    else
      redirect_to patient_path(@event_individuel.patient), alert: 'Erreur lors de la mise à jour du statut.'
    end
  end

  def associate_ordonnance
    authorize @event_individuel, :associate_ordonnance?
    if @event_individuel.update(ordonnance_params)
      redirect_to patient_path(@event_individuel.patient), notice: 'Ordonnance associée avec succès.'
    else
      redirect_to patient_path(@event_individuel.patient), alert: "Erreur lors de l'association de l'ordonnance."
    end
  end

  private

  def set_therapists
    @therapists = Therapist.all # Or however you get your list of therapists
  end

  def event_params
    params.require(:event_individuel).permit(:status, :patient_id, :therapist_id, :start_time, :end_time, :ordonnance_id)
  end

  def ordonnance_params
    params.permit(:ordonnance_id)
  end

  def set_event_individuel
    @event_individuel = EventIndividuel.find(params[:id])
  end
end
