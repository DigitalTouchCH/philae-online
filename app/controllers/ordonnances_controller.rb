class OrdonnancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ordonnance, only: [:show, :edit, :update]

  def new
    @ordonnance = Ordonnance.new
    authorize @ordonnance
  end

  def create
    @ordonnance = Ordonnance.new(ordonnance_params)
    authorize @ordonnance
    if @ordonnance.save
      redirect_to patient_path(@ordonnance.patient_id), notice: 'Ordonnance créée avec succès.'
    else
      render :new
    end
  end

  def update
    authorize @ordonnance
    if @ordonnance.update(ordonnance_params)
      redirect_to patient_path(@ordonnance.patient_id), notice: 'Ordonnance mise à jour avec succès.'
    else
      render :edit
    end
  end

  private

  def set_ordonnance
    @ordonnance = Ordonnance.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to ordonnances_url, alert: 'Ordonnance non trouvée.'
  end

  def ordonnance_params
    params.require(:ordonnance).permit(
      :date_prescription,
      :num_of_session,
      :prescripteur_id,
      :patient_id,
      :commentaire,
      :title,
      :physiotherapy_objectiv,
      :treatment_plan,
      :progress_notes,
      :diagnostic,
      :type_of_ordonnance,
      :is_domicile,
      # Ajoutez d'autres attributs selon votre modèle
    )
  end

end
