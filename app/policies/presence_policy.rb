class PresencePolicy
  attr_reader :user

  # `_record` in this example will be :admin
  def initialize(user, _record)
    @user = user
  end

  def index?
    user.admin?
  end

  def show?
    index?
  end

  def new?
    true
  end

  def create?
    new?
  end

  def edit?
    index?
  end

  def update?
    edit?
  end

  def destroy?
    index?
  end

  def signature_admin?
    user && user.admin?
  end

  def signature_admin_do?
    signature_admin?
  end
end