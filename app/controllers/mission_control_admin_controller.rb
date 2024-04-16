class MissionControlAdminController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    raise ActiveRecord::RecordNotFound unless current_user.super_admin?
  end
end