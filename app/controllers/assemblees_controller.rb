class AssembleesController < ApplicationController
  before_action :set_assemblee, only: %i[ show edit update destroy ]

  # GET /assemblees or /assemblees.json
  def index
    authorize Assemblee
    @assemblees = Assemblee.ordered
  end

  # GET /assemblees/1 or /assemblees/1.json
  def show
  end

  # GET /assemblees/new
  def new
    @assemblee = Assemblee.new
  end

  # GET /assemblees/1/edit
  def edit
  end

  # POST /assemblees or /assemblees.json
  def create
    @assemblee = Assemblee.new(assemblee_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assemblee
      @assemblee = Assemblee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assemblee_params
      params.require(:assemblee).permit(:début, :durée)
    end
end
