class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_policy_scoped, only: :index

  def index
    @users = policy_scope(User)
  end
end
