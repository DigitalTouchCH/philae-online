class WeekAvailabilityPolicy < ApplicationPolicy

  def index?
    user.is_admin? || record == user.therapist
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
