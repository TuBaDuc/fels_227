class WordsController < ApplicationController
  before_action :logged_in_user, unless: :json_request?

  def index
    respond_to do |format|
      @categories = Category.all
      if !params[:category_id].nil? && params[:category_id].empty?
        @words = Word.send params[:option], current_user.id
      elsif category = @categories.find_by(id: params[:category_id])
        @words = category.words.send params[:option], current_user.id
      else
        @words = Word.all
      end
      @words = @words.paginate(page: params[:page],
        per_page: Settings.word_of_list_limit)
      format.html
      format.js
      format.json do
        render json: @words,
          meta: @words.total_pages,
          meta_key: "total_pages",
          status: :ok
      end
    end
  end
end
