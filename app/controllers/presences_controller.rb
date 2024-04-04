class PresencesController < ApplicationController
  before_action :set_presence, only: %i[ show edit update destroy ]
  before_action :is_user_authorized

  # GET /presences or /presences.json
  def index
    @presences = Presence.ordered
    @assemblees = Assemblee.all.order(:nom)

    users = User.all
    @tags = User.all.tag_counts_on(:tags).order(:taggings_count).reverse

    unless params[:tags].blank?
      users = users.tagged_with(params[:tags].reject(&:blank?))
      session[:tags] = params[:tags]
    else
      session[:tags] = params[:tags] = []
    end

    unless params[:search].blank?
      users = users.where("nom ILIKE :search OR prénom ILIKE :search OR email ILIKE :search", {search: "%#{params[:search]}%"})
    end

    users_presences_ids = []
    users.each do |user|
      users_presences_ids << user.presences.pluck(:id)
    end
    @presences = @presences.where(id: users_presences_ids.flatten)

    if params[:assemblee_id].present?
      assemblee = Assemblee.find_by(id: params[:assemblee_id])
      @presences = @presences.where(assemblee_id: assemblee.id)
    end

    respond_to do |format|
      format.html do 
      end

      format.xls do
        book = PresencesToXls.new(@presences).call
        file_contents = StringIO.new
        book.write file_contents # => Now file_contents contains the rendered file output
        filename = "Émargements_#{assemblee.try(:nom)}_#{DateTime.now}.xls"
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end

      format.pdf do
        pdf = PresencePdf.new
        pdf.rapport(@presences.joins(:user).reorder("users.nom"), assemblee)

        send_data pdf.render,
            filename: "Présences_#{assemblee.try(:nom)}_#{DateTime.now}.pdf",
            type: 'application/pdf',
            disposition: 'inline'
      end
    end
  end

  # GET /presences/1 or /presences/1.json
  def show
  end

  # GET /presences/new
  def new
    @presence = Presence.new
    @presence.assemblee = Assemblee.current
    @assemblée_future = Assemblee.where("NOW() < assemblees.début").order(:début).first
  end

  # GET /presences/1/edit
  def edit
  end

  # POST /presences or /presences.json
  def create
    @presence = Presence.new(presence_params)
    @presence.assemblee = Assemblee.current
    @presence.heure = DateTime.now
    @presence.user = current_user

    respond_to do |format|
      if @presence.save
        format.html { redirect_to new_presence_url, notice: "L'émargement a été créé avec succès." }
        format.json { render :show, status: :created, location: @presence }
      else
        format.html do
          @users = [] 
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @presence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /presences/1 or /presences/1.json
  def update
    respond_to do |format|
      if @presence.update(presence_params)
        format.html { redirect_to presences_url, notice: "L'émargement a été modifié avec succès." }
        format.json { render :show, status: :ok, location: @presence }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @presence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presences/1 or /presences/1.json
  def destroy
    @presence.destroy!

    respond_to do |format|
      format.html { redirect_to presences_url, notice: "L'émargement a été supprimé avec succès." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_presence
      @presence = Presence.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def presence_params
      params.require(:presence).permit(:signature)
    end

    def is_user_authorized
      authorize @presence? @presence : Presence
    end
end
