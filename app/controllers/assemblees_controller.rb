class AssembleesController < ApplicationController
  before_action :set_assemblee, only: %i[ show edit update destroy commencer ]
  before_action :is_user_authorized

  # GET /assemblees or /assemblees.json
  def index
    @assemblees = Assemblee.ordered
  end

  # GET /assemblees/1 or /assemblees/1.json
  def show
    respond_to do |format|
      format.html do 
      end

      format.pdf do
        pdf = AssembleePdf.new
        pdf.convocation(@assemblee)

        send_data pdf.render,
            filename: "Assemblée.pdf",
            type: 'application/pdf',
            disposition: 'inline'
      end
    end
  end

  # GET /assemblees/new
  def new
    @assemblee = Assemblee.new
    @assemblee.durée = 2
    @tags = User.tag_counts_on(:tags).order(:name)
  end

  # GET /assemblees/1/edit
  def edit
    @tags = User.tag_counts_on(:tags).order(:name)
  end

  # POST /assemblees or /assemblees.json
  def create
    @assemblee = Assemblee.new(assemblee_params)
    @assemblee.tag_list.add(params[:assemblee][:tags])

    respond_to do |format|
      if @assemblee.save
        format.html { redirect_to assemblees_url, notice: "Assemblée créée avec succès." }
        format.json { render :show, status: :created, location: @assemblee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assemblee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assemblees/1 or /assemblees/1.json
  def update
    respond_to do |format|
      if @assemblee.update(assemblee_params)
        @assemblee.tags.delete_all
        @assemblee.tag_list.add(params[:assemblee][:tags])
        @assemblee.save
        format.html { redirect_to assemblees_url, notice: "Assemblée modifiée avec succès." }
        format.json { render :show, status: :ok, location: @assemblee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assemblee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assemblees/1 or /assemblees/1.json
  def destroy
    @assemblee.destroy!

    respond_to do |format|
      format.html { redirect_to assemblees_url, notice: "Assemblée supprimée avec succès." }
      format.json { head :no_content }
    end
  end

  def commencer
    AssembleeMailer.lien_assemblee(@assemblee).deliver_now
    redirect_to request.referrer, notice: "Lien de signature envoyée au gestionnaire."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assemblee
      @assemblee = Assemblee.find_by(slug: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assemblee_params
      params.require(:assemblee).permit(:nom, :début, :durée, :adresse, :user_id, :tag_list, :automatique)
    end

    def is_user_authorized
      authorize Assemblee
    end
end
