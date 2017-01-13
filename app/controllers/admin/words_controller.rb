class Admin::WordsController < ApplicationController
  before_action :load_category, only: [:new]

  def new
    @word = @category.words.build
  end

  def create
    @word = Word.new word_params
    unless is_choose_a_correct_answer @word
      flash.now[:danger] = t :must_choose_a_correct_answer
      render :new
      return
    end
    if @word.save
      flash[:success] = t :create_word_success_mess
      redirect_to [:admin, @word.category]
    else
      flash.now[:danger] = t :create_word_fail_mess
      render :new
    end
  end

  private
  def word_params
    params.require(:word).permit :content, :category_id,
      answers_attributes: [:id, :content, :is_correct, :_destroy]
  end

  def is_choose_a_correct_answer word
    word.answers.select{|answer| answer.is_correct}.size >= 1 ? true : false
  end
end
