class UsersController < ApplicationController
  # http_basic_authenticate_with name: "admin", password: "1234", only: :new
  # USERS = { 
  #   "nelson" => "nelson",
  #   'pedro' => 'pedro'
  # }
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # before_action :authenticate, only: :new
  # skip_before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
   @users  = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html { render :show, status: :show, location: @user }
      format.json { render :show, status: :show, location: @user }
    end
  end

  # GET /users/new
  def new
    @user = User.new(name: cookies[:user_name])
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        cookies[:user_name] = user_params[:name]
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        cookies.delete(:user_name)
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def authenticate
      authenticate_or_request_with_http_digest do |username|
        USERS[username]
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
