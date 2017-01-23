class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_category, except: [:index, :new, :create]
  before_action :verify_category_empty, only: [:destroy]

  def index
    @categories = Category.search(params[:name]).order(name: :desc)
    respond_to do |format|
      format.html {
        @categories = @categories.paginate(page: params[:page],
          per_page: Settings.admin_category_limit)
      }
      format.xlsx do
        render xlsx: "index",
        filename: "categories_#{Time.now.strftime("%Y%m%d%H%M%S")}",
        disposition: "inline"
      end
    end
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

  def show
    @words = @category.words.order(created_at: :desc)
    respond_to do |format|
      format.html {
        @words = @words.paginate(page: params[:page],
          per_page: Settings.admin_word_limit)
      }
      format.xlsx do
        render xlsx: "category_words",
        filename: "category_#{@category.id}_words_#{Time.now.strftime("%Y%m%d%H%M%S")}",
        disposition: "inline"
      end
    end
  end

  private
  def category_params
    params.require(:category).permit :name, :description, :photo
  end

  def verify_category_empty
    if @category.words.any?
      flash[:danger] = t :category_not_empty, name: @category.name
      redirect_to admin_categories_path
    end
  end
end
