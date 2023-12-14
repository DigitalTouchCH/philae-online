class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_policy_scoped, only: :index

  def index
    @users = policy_scope(User).includes(:therapist, :patient)
    @therapist_users = @users.where.not(therapists: { id: nil })
    @patient_users = @users.where.not(patients: { id: nil })
    @other_users = @users.where(therapists: { id: nil }, patients: { id: nil })
  end


  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to users_path, notice: "Mise à jour de l'utilisateur effectuée"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :is_admin,
      :therapist_id,
      :patient_id,
      :first_name,
      :last_name,
      # Ajoutez ici d'autres paramètres si nécessaire, par exemple pour le mot de passe:
      # :password,
      # :password_confirmation,
    )
  end
end
