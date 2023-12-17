class EventIndividuelsController < ApplicationController
  before_action :set_event_individuel, only: [:update_status, :associate_ordonnance]


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

  def event_params
    params.require(:event_individuel).permit(:status)
  end

  def ordonnance_params
    params.permit(:ordonnance_id)
  end

  def set_event_individuel
    @event_individuel = EventIndividuel.find(params[:id])
  end
end
