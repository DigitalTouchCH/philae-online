class EventIndividuelPolicy < ApplicationPolicy

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
