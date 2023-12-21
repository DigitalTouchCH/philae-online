# app/policies/therapist_policy.rb

class TherapistPolicy < ApplicationPolicy

  def services?
  end

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

  def create?
    user.is_admin?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def update?
    user.is_admin? || record.user == user
  end

  def destroy?
    user.is_admin?
  end

  class Scope < Scope
    def resolve
      if user.is_admin?
        scope.all
      elsif user.therapist?
        scope.where(id: user.therapist.id)
      elsif user.firm.present?
        scope.where(firm: user.firm)
      else
        scope.none
      end
    end
  end
end
