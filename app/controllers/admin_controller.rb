class AdminController < ApplicationController

  def index
    authorize :admin
  end

end
