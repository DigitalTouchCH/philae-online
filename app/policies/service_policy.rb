class ServicePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.is_admin?
  end

  def create?
    user.is_admin?
  end

  def new?
    create?
  end

  def update?
    user.is_admin?
  end

  def edit?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
