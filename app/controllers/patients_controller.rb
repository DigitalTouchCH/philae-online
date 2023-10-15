class PatientsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_policy_scoped, only: :index

  def index
    @patients = policy_scope(Patient)
  end

end
