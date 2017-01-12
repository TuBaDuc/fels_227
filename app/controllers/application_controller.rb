class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t :please_login
    redirect_to login_url
  end

  def load_user
    @user = User.find_by id: params[:id] || params[:user_id]
    if @user.nil?
      flash[:danger] = t :user_nil_mess
      redirect_to root_url
    end
  end

  def verify_admin
    redirect_to root_url unless current_user.is_admin?
  end

  def check_correct_user
    return true if current_user.is_admin?
    unless current_user?@user
      flash[:danger] = t :error_permission_mess
      redirect_to root_url
    end
  end

  def load_category
    @category = Category.find_by id: params[:id] || params[:category_id]
    if @category.nil?
      flash[:danger] = t :category_nil_mess
      back = current_user.is_admin ? admin_categories_path : categories_path
      redirect_to back
    end
  end
end
