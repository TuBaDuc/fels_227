class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user, :verify_admin

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t :create_category_success_mess
      redirect_to new_admin_category_path
    else
      flash.now[:danger] = t :create_category_fail_mess
      render :new
    end
  end

  private
  def category_params
    params.require(:category).permit :name, :description, :photo
  end
end
