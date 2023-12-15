class OrdonnancePolicy < ApplicationPolicy

  def new?
    user&.is_admin? || user&.therapist?
  end

  def create?
    user&.is_admin? || user&.therapist?
  end

  def update?
    user&.is_admin? || user&.therapist?
  end

  class Scope < Scope
    def resolve
      if user&.is_admin? || user&.therapist?
        scope.all
      else
        scope.none
      end
    end
  end
end
