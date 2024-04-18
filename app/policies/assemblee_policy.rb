class AssembleePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user && user.admin?
  end

  def show?
    index? && record.organisation.users.include?(user)
  end

  def new?
    index?
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

  def envoyer_lien_gestionnaire?
    show?
  end
end