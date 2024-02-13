class UserPolicy
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
    index?
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
end