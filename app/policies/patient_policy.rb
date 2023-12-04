class PatientPolicy < ApplicationPolicy
  def index?
    user&.is_admin? || user&.therapist?
  end

  def show?
    user&.is_admin? || user&.therapist?
  end

  def new?
    user&.is_admin? || user&.therapist?
  end

  def create?
    user&.is_admin? || user&.therapist?
  end

  def edit?
    user&.is_admin? || user&.therapist?
  end

  def update?
    user&.is_admin? || user&.therapist?
  end

  def destroy?
    user&.is_admin?
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
