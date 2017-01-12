class CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :load_category, only: [:show]

  def index
    @categories = Category.search(params[:name]).order(created_at: :desc)
      .paginate page: params[:page], per_page: Settings.user_category_limit
  end

  def show
  end
end
