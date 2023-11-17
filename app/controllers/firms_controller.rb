class FirmsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_policy_scoped, only: :index
  before_action :set_firm, only: [:show, :edit, :update, :destroy]


  def index
    @firms = policy_scope(Firm)
  end

  def show
    authorize @firm
  end

  def new
    @firm = Firm.new
    authorize @firm
  end

  def create
    @firm = Firm.new(firm_params)
    authorize @firm

    if @firm.save
      redirect_to firms_path, notice: 'Firm was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    authorize @firm
    if @firm.update(firm_params)
      redirect_to firms_path, notice: 'La société a été mise à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @firm
    @firm.therapists.update_all(firm_id: nil)
    if @firm.destroy
      redirect_to firms_url, notice: 'Firm was successfully destroyed.'
    else
      redirect_to firms_url, alert: 'Firm could not be destroyed. Please make sure all dependencies are removed.'
    end
  end

  private
  def firm_params
    params.require(:firm).permit(:name, :address, therapist_ids: [])
  end

  def set_firm
    @firm = Firm.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to firms_url, alert: 'Firm not found.'
  end
end
