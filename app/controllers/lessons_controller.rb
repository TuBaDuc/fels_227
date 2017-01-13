class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :load_category, only: [:create]

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
end
