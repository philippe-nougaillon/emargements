class PresencesController < ApplicationController
  before_action :set_presence, only: %i[ show edit update destroy ]

  # GET /presences or /presences.json
  def index
    authorize Presence
    @presences = Presence.ordered
  end

  # GET /presences/1 or /presences/1.json
  def show
  end

  # GET /presences/new
  def new
    @presence = Presence.new
    @presence.assemblee_id = Assemblee.where("DATE(assemblees.début) = ?", Date.today).first.id
    @participants = Participant.where.not(id: Presence.where(assemblee_id: @presence.assemblee_id).pluck(:participant_id)).ordered
  end

  # GET /presences/1/edit
  def edit
  end

  # POST /presences or /presences.json
  def create
    @presence = Presence.new(presence_params)
    @presence.assemblee_id = Assemblee.where("DATE(assemblees.début ) = ?", Date.today).first.id
    @presence.heure = DateTime.now

    respond_to do |format|
      if @presence.save
        format.html { redirect_to new_presence_url, notice: "L'émargement de '#{@presence.participant.nom_prénom}' a été créé avec succès." }
        format.json { render :show, status: :created, location: @presence }
      else
        format.html { render :new, status: :unprocessable_entity }
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
      params.require(:presence).permit(:participant_id, :signature)
    end
end
