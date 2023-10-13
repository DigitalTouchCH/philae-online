class FirmsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_policy_scoped, only: :index

  def index
    @firms = policy_scope(Firm)
  end
end
