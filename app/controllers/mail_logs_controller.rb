class MailLogsController < ApplicationController
  before_action :set_mail_log, only: %i[ show edit update destroy ]

  # GET /mail_logs or /mail_logs.json
  def index
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"], 'api.eu.mailgun.net'
    domain = ENV["MAILGUN_DOMAIN"]
    @result_failed = mg_client.get("#{domain}/events", {:event => 'failed'}).to_h
    @result_opened = {}.to_h

    @mail_logs = current_user.organisation.mail_logs.ordered

    unless params[:search].blank?
      @mail_logs = @mail_logs.where("LOWER(mail_logs.to) like :search", {search: "%#{params[:search]}%".downcase})
    end

    unless params[:search_subject].blank?
      @mail_logs = @mail_logs.where(subject: params[:search_subject])
    end

    if params[:ko].blank?
      @result_opened = mg_client.get("#{domain}/events", {:event => 'opened'}).to_h
    end
  end

  # GET /mail_logs/1 or /mail_logs/1.json
  def show
  end

  # GET /mail_logs/new
  def new
    @mail_log = MailLog.new
  end

  # GET /mail_logs/1/edit
  def edit
  end

  # POST /mail_logs or /mail_logs.json
  def create
    @mail_log = MailLog.new(mail_log_params)

    respond_to do |format|
      if @mail_log.save
        format.html { redirect_to mail_log_url(@mail_log), notice: "Mail log was successfully created." }
        format.json { render :show, status: :created, location: @mail_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mail_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mail_logs/1 or /mail_logs/1.json
  def update
    respond_to do |format|
      if @mail_log.update(mail_log_params)
        format.html { redirect_to mail_log_url(@mail_log), notice: "Mail log was successfully updated." }
        format.json { render :show, status: :ok, location: @mail_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mail_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_logs/1 or /mail_logs/1.json
  def destroy
    @mail_log.destroy!

    respond_to do |format|
      format.html { redirect_to mail_logs_url, notice: "Mail log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_log
      @mail_log = MailLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mail_log_params
      params.require(:mail_log).permit(:to, :subject, :message_id)
    end
end
