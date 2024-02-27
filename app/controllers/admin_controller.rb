class AdminController < ApplicationController

  def index
    authorize :admin
    @assemblees = Assemblee.order(:début).where("DATE(assemblees.début) BETWEEN ? AND ?", Date.today - 1.month, Date.today + 2.months)
  end

  def signature
    @presence = Presence.new
    @presence.assemblee = Assemblee.where("NOW() BETWEEN assemblees.début AND assemblees.fin").first
    @assemblée_future = Assemblee.where("NOW() < assemblees.début").first
    @users_not_signed = User.where.not(id: Presence.where(assemblee_id: @presence.assemblee_id).pluck(:user_id)).ordered
  end

  def signature_do
    @presence = Presence.new(user_id: params[:user_id], signature: params[:signature])
    @presence.assemblee = Assemblee.where("NOW() BETWEEN assemblees.début AND assemblees.fin").first
    @presence.heure = DateTime.now

    respond_to do |format|
      if @presence.save
        format.html { redirect_to admin_signature_url, notice: "L'émargement de #{@presence.user.nom_prénom} a été créé avec succès." }
        format.json { render :show, status: :created, location: @presence }
      else
        format.html do
          @users_not_signed = [] 
          render :signature, status: :unprocessable_entity
        end
        format.json { render json: @presence.errors, status: :unprocessable_entity }
      end
    end
  end
end
