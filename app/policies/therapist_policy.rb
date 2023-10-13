# app/policies/therapist_policy.rb

class TherapistPolicy < ApplicationPolicy
  def show?
    user.is_admin? || record == user.therapist
  end

  def events?
    show?
  end

  class Scope < Scope
    def resolve
      if user.is_admin?
        # Si l'utilisateur est un admin, il peut voir tous les thérapeutes
        scope.all
      else
        # Sinon, il peut seulement voir les thérapeutes dans sa propre entreprise, par exemple
        scope.where(firm: user.therapist.firm)
      end
    end
  end
end
