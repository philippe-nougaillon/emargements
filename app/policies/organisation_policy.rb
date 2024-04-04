class OrganisationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    user && user.admin? && record.users.include?(user)
  end

  def edit?
    show?
  end

  def update?
    edit?
  end
end