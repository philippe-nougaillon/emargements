class AssembleesController < ApplicationController
  before_action :set_assemblee, only: %i[ show edit update destroy commencer ]
  before_action :is_user_authorized

  # GET /assemblees or /assemblees.json
  def index
    @assemblees = current_user.organisation.assemblees.ordered

    unless params[:search].blank?
      @assemblees = @assemblees.where("nom ILIKE :search OR adresse ILIKE :search", {search: "%#{params[:search]}%"})
    end

    unless params[:date].blank?
      @assemblees = @assemblees.where("DATE(début) = ?", params[:date])
    end
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
            filename: "#{@assemblee.nom}-#{l @assemblee.début.to_date} #{DateTime.now}.pdf",
            type: 'application/pdf',
            disposition: 'inline'
      end
    end
  end

  # GET /assemblees/new
  def new
    @assemblee = Assemblee.new
    @tags = current_user.organisation.users.tag_counts_on(:tags).order(:name)
    @users = current_user.organisation.users.tagged_with("Gestionnaire")

    @assemblee.début = DateTime.now.change(min: 0, sec: 0) + 1.hour
    @assemblee.durée = 2
  end

  # GET /assemblees/1/edit
  def edit
    @tags = current_user.organisation.users.tag_counts_on(:tags).order(:name)
    @users = current_user.organisation.users.tagged_with("Gestionnaire")
  end

  # POST /assemblees or /assemblees.json
  def create
    @assemblee = Assemblee.new(assemblee_params)
    @assemblee.tag_list.add(params[:assemblee][:tags])
    @assemblee.organisation = current_user.organisation

    respond_to do |format|
      if @assemblee.save
        format.html do 
          redirect_to current_user.organisation.step < 4 ? admin_index_path : assemblees_url
          flash[:notice] = "Assemblée créée avec succès."
        end
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
    mailer_response = AssembleeMailer.lien_assemblee(@assemblee).deliver_now
    MailLog.create(user_id: current_user, message_id: mailer_response.message_id, to: @assemblee.user.email, subject: "Lien assemblée gestionnaire manuel")
    redirect_to request.referrer, notice: "Lien de signature envoyée au gestionnaire."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assemblee
      @assemblee = Assemblee.find_by(slug: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assemblee_params
      params.require(:assemblee).permit(:nom, :début, :durée, :adresse, :user_id, :tag_list, :automatique, :notifier_participants)
    end

    def is_user_authorized
      authorize @assemblee ? @assemblee : Assemblee
    end
end
