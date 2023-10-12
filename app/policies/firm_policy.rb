class FirmPolicy < ApplicationPolicy

  def index?
    user.is_admin? || user.therapist?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
