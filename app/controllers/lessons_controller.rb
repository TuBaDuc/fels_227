class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :load_category, :verify_enough_word, only: [:create]
  before_action :load_lesson, only: [:show, :destroy]

  def show
  end

  def create
    @lesson = current_user.lessons.build category_id: @category.id
    if @lesson.save
      flash[:success] = t :create_lesson_success_mess
      redirect_to @lesson
    else
      flash[:danger] = t :create_lesson_fail_mess
      redirect_to @category
    end
  end

  def destroy
    if @lesson.destroy
      flash[:success] = t :lesson_delete_success_mes
    else
      flash[:danger] = t :lesson_delete_fail_mes
    end
    redirect_to @lesson.category
  end

  private

  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
    if @lesson.nil?
      flash[:danger] = t :lesson_nil_mess
      redirect_to categories_path
    end
  end

  def verify_enough_word
    unless @category.words.size >= Settings.word_of_lesson_limit
      flash[:danger] =
        t :min_words_for_lesson_mess, min: Settings.word_of_lesson_limit
      redirect_to categories_path
    end
  end
end
