class AdminController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[signature_collective signature_collective_do signature_individuelle signature_individuelle_do]
  before_action :is_user_authorized, except: %i[signature_collective signature_collective_do signature_individuelle signature_individuelle_do]
  before_action :set_tags, only: %i[import create_new_participant]

  def index
    @assemblees = current_user
                    .organisation
                    .assemblees
                    .order(:début)
                    .where("DATE(assemblees.début) BETWEEN ? AND ?", Date.today - 1.month, Date.today + 2.months)


    @current_step = current_user.organisation.step
  end

  def signature_collective
    if assemblee = Assemblee.find_by(slug: params[:assemblee_id])
      @presence = Presence.new
      @presence.assemblee = assemblee
      @users_not_signed = assemblee.users_not_signed
    else 
      redirect_to root_path, alert: "Problème avec l'UUID"
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
          render :signature_collective, status: :unprocessable_entity
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
      redirect_to root_path, alert: "Problème avec l'UUID"
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
          render :signature_individuelle, status: :unprocessable_entity
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
    @actions= %i[create update destroy]

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

  def create_new_admin
    @user = User.new
  end

  def create_new_admin_do
    @user = User.new(params.require(:user).permit(:nom, :prénom, :email, :password))
    @user.organisation = current_user.organisation
    @user.admin = true
    @user.skip_confirmation!

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "Administrateur créé avec succès." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :create_new_admin, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_new_participant
    @user = User.new
  end

  def create_new_participant_do
    @user = User.new(params.require(:user).permit(:nom, :prénom, :email))
    @user.tag_list.add(params[:user][:tags])
    @user.password = SecureRandom.hex(5)
    @user.organisation = current_user.organisation
    @user.skip_confirmation!

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "Participant créé avec succès." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :create_new_admin, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def fake_signatures_detector
    @batch_prediction_jobs = GetBatchPredictionJobs.call
  end

  def fake_signature_detector
    @batch_prediction_job = GetBatchPredictionJob.call(params[:batch_prediction_job])
    @downloaded = GetGoogleCloudStorageFile.call(@batch_prediction_job)
  end

  def launch_fake_signature_detector
    CreateBatchPredictionJob.call(current_user.organisation_id)
    respond_to do |format|
      format.html { redirect_to admin_fake_signatures_detector_url, notice: "Détection lancée" }
    end
  end

  private

  def is_user_authorized
    authorize :admin
  end

  def set_tags
    @tags = current_user.organisation.tags
  end
end
