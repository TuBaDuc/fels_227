class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.order(name: :desc)
      .paginate page: params[:page],
        per_page: Settings.admin_category_entry_per_page
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t :category_update_success_mess
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t :category_update_fail_mess
      render :edit
    end
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t :create_category_success_mess
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t :create_category_fail_mess
      render :new
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t :category_delete_success_mess
    else
      flash[:danger] = t :category_delete_fail_mess
    end
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit :name, :description, :photo
  end

  def load_category
    @category = Category.find_by id: params[:id]
    if @category.nil?
      flash[:danger] = t :category_nil_mess
      redirect_to admin_categories_path
    end
  end
end
