class PrescripteursController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prescripteur, only: [:edit, :update]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    if params[:search].present?
      search_query = "%#{params[:search]}%"
      @prescripteurs = policy_scope(Prescripteur).includes(:ordonnances).order(:name).where("name ILIKE ?", search_query)
    else
      @prescripteurs = policy_scope(Prescripteur).includes(:ordonnances).order(:name)
    end
  end

  def new
    @prescripteur = Prescripteur.new
    authorize @prescripteur
  end

  def create
    @prescripteur = Prescripteur.new(prescripteur_params)
    authorize @prescripteur
    if @prescripteur.save
      redirect_to prescripteurs_path, notice: 'Le prescripteur a été créé.'
    else
      render :new
    end
  end

  def edit
    authorize @prescripteur
  end

  def update
    authorize @prescripteur
    if @prescripteur.update(prescripteur_params)
      redirect_to prescripteurs_path, notice: 'Le prescripteur a été mis à jour.'
    else
      render :edit
    end
  end

  private

  def set_prescripteur
    @prescripteur = Prescripteur.find(params[:id])
  end

  def prescripteur_params
    params.require(:prescripteur).permit(:name, :address, :tel, :mail)
  end

end
