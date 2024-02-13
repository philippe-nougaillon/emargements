class UserPolicy
  attr_reader :user

  # `_record` in this example will be :admin
  def initialize(user, _record)
    @user = user
  end

  def index?
    user.admin?
  end

end