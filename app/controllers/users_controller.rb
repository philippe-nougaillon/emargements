class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :is_user_authorized

  # GET /users or /users.json
  def index
    @users = current_user.organisation.users.ordered

    @tags = @users.tag_counts_on(:tags).order(:taggings_count).reverse

    @assemblees = Assemblee.all.order(:nom)

    unless params[:tags].blank?
      @users = @users.tagged_with(params[:tags].reject(&:blank?))
      session[:tags] = params[:tags]
    else
      session[:tags] = params[:tags] = []
    end

    unless params[:assemblee_id].blank?
      @users = @users.where(id: Assemblee.find(params[:assemblee_id]).related_users)
    end

    unless params[:search].blank?
      @users = @users.where("nom ILIKE :search OR prénom ILIKE :search OR email ILIKE :search", {search: "%#{params[:search]}%"})
    end

    if params[:admin] == "on"
      @users = @users.where(admin: true)
    end
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.organisation = current_user.organisation

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "Utilisateur créé avec succès." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "Utilisateur modifié avec succès." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "Utilisateur supprimé avec succès." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(slug: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:nom, :prénom, :email, :adresse, :tag_list, :password)
    end

    def is_user_authorized
      authorize @user ? @user : User
    end
end
