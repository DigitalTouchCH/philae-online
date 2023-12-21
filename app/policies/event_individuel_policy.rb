class EventIndividuelPolicy < ApplicationPolicy

  def new?
    user.present?
  end

  def create?
    new?
  end

  def update_status?
    user&.is_admin? || user&.therapist?
  end

  def associate_ordonnance?
    user&.is_admin? || user&.therapist?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
