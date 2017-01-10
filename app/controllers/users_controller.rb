class UsersController < ApplicationController
  before_action :load_user, only: [:show, :update, :edit]
  before_action :logged_in_user, :check_correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to root_url
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t :user_edit_profile_updated
      redirect_to @user
    else
      render :edit
    end
  end

  def index
    @users = User.search(params[:name]).paginate(page: params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation, :phone, :address)
  end

end
