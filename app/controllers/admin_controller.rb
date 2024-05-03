class AdminController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[signature_collective signature_collective_do signature_individuelle signature_individuelle_do]
  before_action :is_user_authorized, except: %i[signature_collective signature_collective_do signature_individuelle signature_individuelle_do]

  def index
    @assemblees = current_user.organisation.assemblees.order(:début).where("DATE(assemblees.début) BETWEEN ? AND ?", Date.today - 1.month, Date.today + 2.months)
  end

  def signature_collective
    if assemblee = Assemblee.find_by(slug: params[:assemblee_id])
      @presence = Presence.new
      @presence.assemblee = assemblee
      @users_not_signed = assemblee.users_not_signed
    else 
      redirect_to root_path, alert: "Problème avec l'uuid"
    end
  end

  def signature_collective_do
    @presence = Presence.new(signature: params[:signature])
    @presence.assemblee = Assemblee.find_by(slug: params[:assemblee_id])
    @presence.user = User.find_by(slug: params[:user_id])
    @presence.heure = DateTime.now

    respond_to do |format|
      if @presence.save
        format.html { redirect_to admin_signature_collective_url(assemblee_id: params[:assemblee_id]), notice: "L'émargement de #{@presence.user.nom_prénom} a été créé avec succès." }
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

  def signature_individuelle
    if (assemblee = Assemblee.find_by(slug: params[:assemblee_id])) && (user = User.find_by(slug: params[:user_id])) && assemblee.related_users.include?(user.id)
      @presence = Presence.new
      @presence.assemblee = assemblee
      @presence.user = user
    else 
      redirect_to root_path, alert: "Problème avec l'uuid"
    end
  end

  def signature_individuelle_do
    @presence = Presence.new(signature: params[:signature])
    @presence.assemblee = Assemblee.find_by(slug: params[:assemblee_id])
    @presence.user = User.find_by(slug: params[:user_id])
    @presence.heure = DateTime.now

    respond_to do |format|
      if @presence.save
        format.html { redirect_to admin_signature_individuelle_url(assemblee_id: params[:assemblee_id], user_id: params[:user_id]), notice: "Votre émargement a été créé avec succès." }
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
    users_infos = params[:content].split("\r\n")
    users_imported = ImportUsers.new(users_infos, current_user.organisation_id, params[:groupes]).call
    redirect_to root_path, notice: "#{users_imported} participant(s) importé(s) sur #{users_infos.count}"
  end

  def audits
    @organisation_audits = Audited::Audit.where(user_id: current_user.organisation.users.pluck(:id))
    @audits = @organisation_audits.order("id DESC")
    @types  = @organisation_audits.pluck(:auditable_type).uniq.sort
    @actions= %w[update create destroy]

    if params[:start_date].present? && params[:end_date].present? 
      @audits = @audits.where("created_at BETWEEN (?) AND (?)", params[:start_date], params[:end_date])
    end

    if params[:type].present?
      @audits = @audits.where(auditable_type: params[:type])
    end

    if params[:action_name].present?
      @audits = @audits.where(action: params[:action_name])
    end

    if params[:search].present?
      @audits = @audits.where("audited_changes ILIKE ?", "%#{params[:search]}%")
    end

  end

  def premium
    if params[:alert].present?
      flash.alert = "Le quotat gratuit de participants est atteint. Passez au PREMIUM pour être en illimité"
    end
  end

  private

  def is_user_authorized
    authorize :admin
  end
end
