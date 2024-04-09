class PresencePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user && user.admin?
  end

  def show?
    index? && record.assemblee.organisation.users.include?(user)
  end

  def new?
    true
  end

  def create?
    new?
  end

  def edit?
    show?
  end

  def update?
    edit?
  end

  def destroy?
    show?
  end
end