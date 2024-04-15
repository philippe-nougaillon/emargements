class MailLogPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user && user.admin? && user.premium?
  end

  def show?
    index? && record.organisation.users.include?(user)
  end
end