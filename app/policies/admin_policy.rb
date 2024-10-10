class AdminPolicy
  attr_reader :user

  # `_record` in this example will be :admin
  def initialize(user, _record)
    @user = user
  end

  def index?
    user && user.admin?
  end

  def import?
    index? && (user.organisation.premium || user.organisation.users.count < 50)
  end

  def import_do?
    import?
  end

  def audits?
    index? && user.premium?
  end

  def premium?
    index?
  end

  def create_new_admin?
    index?
  end

  def create_new_admin_do?
    create_new_admin?
  end

  def create_new_participant?
    index?
  end

  def create_new_participant_do?
    create_new_participant?
  end

  def fake_signatures_detector?
    index? && user.premium?
  end

  def fake_signature_detector?
    fake_signatures_detector?
  end

end