# app/policies/therapist_policy.rb

class TherapistPolicy < ApplicationPolicy
  def show?
    user.is_admin? || record == user.therapist
  end

  def events?
    show?
  end

  def all_events?
    true
  end

  def update_event?
    show?
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
