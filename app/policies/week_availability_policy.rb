class WeekAvailabilityPolicy < ApplicationPolicy

  def index?
    user.is_admin? || user.therapist
  end

  def edit?
    user.is_admin? || user.therapist&.is_manager?
  end

  def update?
    user.is_admin? || user.therapist&.is_manager?
  end

  class Scope < Scope
    def resolve
      if user.is_admin?
        scope.all
      else
        scope.where(therapist_id: user.therapist.id)
      end
    end
  end

end
