class UserPolicy < ApplicationPolicy
  def index?
    user.is_admin?
  end

  def edit?
    user.is_admin?
  end

  def update?
    user.is_admin?
  end

  class Scope < Scope
    def resolve
      if user.is_admin?
        scope.all
      else
        scope.none
      end
    end
  end
end
