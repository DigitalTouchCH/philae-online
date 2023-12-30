class TimeBlockPolicy < ApplicationPolicy
  def index?
    user.is_admin? || user.therapist&.is_manager?
  end

  def edit?
    user.is_admin? || user.therapist&.is_manager?
  end

  def update?
    user.is_admin? || user.therapist&.is_manager?

  end

  def destroy?
    user.is_admin? || user.therapist&.is_manager?
  end

  def create?
    user.is_admin? || user.therapist&.is_manager?
  end

  def new?
    user.is_admin? || user.therapist&.is_manager?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
