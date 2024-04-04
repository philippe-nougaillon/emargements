class AdminController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[signature signature_do]
  before_action :is_user_authorized, except: %i[signature signature_do]

  def index
    @assemblees = current_user.organisation.assemblees.order(:début).where("DATE(assemblees.début) BETWEEN ? AND ?", Date.today - 1.month, Date.today + 2.months)
  end

  def signature
    @presence = Presence.new
    if assemblee = Assemblee.find_by(slug: params[:assemblee_id])
      @presence.assemblee = assemblee
      @users_not_signed = assemblee.users_not_signed
    else 
      redirect_to root_path, alert: "Problème avec l'uuid"
    end
  end

  def signature_do
    @presence = Presence.new(user_id: params[:user_id], signature: params[:signature])
    @presence.assemblee = Assemblee.find_by(slug: params[:assemblee_id])
    @presence.heure = DateTime.now

    respond_to do |format|
      if @presence.save
        format.html { redirect_to admin_signature_url(assemblee_id: params[:assemblee_id]), notice: "L'émargement de #{@presence.user.nom_prénom} a été créé avec succès." }
        format.json { render :show, status: :created, location: @presence }
      else
        format.html do
          @users_not_signed = @presence.assemblee.users_not_signed
          render :signature, status: :unprocessable_entity
        end
        format.json { render json: @presence.errors, status: :unprocessable_entity }
      end
    end
  end

  def import

  end

  def import_do
    users_saved = 0
    emails = params[:content].split("\r\n")
    emails.each_with_index do |email, index|
      user = User.create(email: email, password: SecureRandom.hex(5), organisation_id: current_user.organisation_id)
      user.tag_list.add(params[:groupes].split(','))
      user.dispatch_email_to_nom_prénom
      if user.save
        users_saved += 1
      end
    end
    redirect_to admin_index_path, notice: "#{users_saved} participants importés sur #{emails.count}"
  end

  private

  def is_user_authorized
    authorize :admin
  end
end
