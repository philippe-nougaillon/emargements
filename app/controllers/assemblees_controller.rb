class AssembleesController < ApplicationController
  before_action :set_assemblee, only: %i[ show edit update destroy envoyer_lien_gestionnaire ]
  before_action :is_user_authorized
  before_action :set_tags, only: %i[ new edit import ]

  # GET /assemblees or /assemblees.json
  def index
    @assemblees = current_user.organisation.assemblees.ordered
    @tags = @assemblees.tag_counts_on(:tags).order(:taggings_count).reverse

    if params[:search].present?
      @assemblees = @assemblees.where("nom ILIKE :search OR adresse ILIKE :search", {search: "%#{params[:search]}%"})
    end

    if params[:tags].present?
      @assemblees = @assemblees.tagged_with(params[:tags].reject(&:blank?))
      session[:tags] = params[:tags]
    else
      session[:tags] = params[:tags] = []
    end

    if params[:debut].present?
      if params[:fin].present?
        @assemblees = @assemblees.where("DATE(début) BETWEEN ? AND ?", params[:debut], params[:fin])
      else
        @assemblees = @assemblees.where("DATE(début) = ?", params[:debut])
      end
    end

    respond_to do |format|
      format.html

      format.ics do
        filename = "Export_iCalendar_#{Date.today.to_s}"
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.ics"'
        headers['Content-Type'] = "text/calendar; charset=UTF-8"
        render plain: AssembleesToIcalendar.new(@assemblees).call
      end
    end
  end

  # GET /assemblees/1 or /assemblees/1.json
  def show
    respond_to do |format|
      format.html

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
    if params[:assemblee_id].present?
      assemblee_old = Assemblee.find_by(slug: params[:assemblee_id])
      @assemblee.nom = assemblee_old.nom
      @assemblee.tags = assemblee_old.tags
      @assemblee.début = assemblee_old.début
      @assemblee.fin = assemblee_old.fin
      @assemblee.durée = assemblee_old.durée
      @assemblee.adresse = assemblee_old.adresse
      @assemblee.automatique = assemblee_old.automatique
      @assemblee.notifier_participants = assemblee_old.notifier_participants            
    else
      @assemblee.début = DateTime.now.change(min: 0, sec: 0) + 1.hour
      @assemblee.durée = 2
    end
  end

  # GET /assemblees/1/edit
  def edit
  end

  # POST /assemblees or /assemblees.json
  def create
    @assemblee = Assemblee.new(assemblee_params)
    @assemblee.tag_list.add(params[:assemblee][:tags])
    @assemblee.organisation = current_user.organisation
    @assemblee.user = current_user

    respond_to do |format|
      if @assemblee.save
        unless Rails.env.development?
          Events.instance.publish('assemblee.created', payload: {assemblee_id: @assemblee.id})
        end
        format.html do 
          redirect_to current_user.organisation.step < 4 ? admin_index_path : assemblees_url
          flash[:notice] = "Session créée avec succès."
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
        @assemblee.tag_list = params[:assemblee][:tags]
        @assemblee.save
        format.html { redirect_to assemblees_url, notice: "Session modifiée avec succès." }
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
      format.html { redirect_to assemblees_url, notice: "Session supprimée avec succès." }
      format.json { head :no_content }
    end
  end

  def envoyer_lien_gestionnaire
    EnvoyerLienSignatureCollectiveJob.perform_later(@assemblee, current_user.id)
    redirect_to assemblees_path, notice: "Lien de signature envoyé au gestionnaire."
  end

  def import
  end

  def import_do
    assemblees_infos = params[:assemblees].split("\r\n")
    assemblees_imported = ImportAssemblees.new(assemblees_infos, current_user, params[:groupes]).call
    redirect_to assemblees_path, notice: "#{assemblees_imported} session(s) importée(s) sur #{assemblees_infos.count}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assemblee
      @assemblee = Assemblee.find_by(slug: params[:id])
    end
    
    def set_tags
      @tags = current_user.organisation.tags
    end

    # Only allow a list of trusted parameters through.
    def assemblee_params
      params.require(:assemblee).permit(:nom, :début, :durée, :adresse, :user_id, :tag_list, :automatique, :notifier_participants)
    end

    def is_user_authorized
      authorize @assemblee ? @assemblee : Assemblee
    end

end
