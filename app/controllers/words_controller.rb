class WordsController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = Category.all
    if !params[:category_id].nil? && params[:category_id].empty?
      @words = Word.send params[:option], current_user.id
    elsif category = @categories.find_by(id: params[:category_id])
      @words = category.words.send params[:option], current_user.id
    else
      @words = Word.all
    end

    respond_to do |format|
      format.any(:html, :js) {
        @words = @words.paginate(page: params[:page],
          per_page: Settings.word_of_list_limit)
      }
      format.xlsx do
        render xlsx: "index",
        filename: "words_#{Time.now.strftime("%Y%m%d%H%M%S")}",
        disposition: "inline"
      end
    end
  end
end
