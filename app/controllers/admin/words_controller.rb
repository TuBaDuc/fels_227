class Admin::WordsController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_category, only: [:new]
  before_action :load_word, only: [:edit, :update, :destroy]

  def new
    @word = @category.words.build
  end

  def create
    @word = Word.new word_params
    if @word.save
      flash[:success] = t :create_word_success_mess
      redirect_to [:admin, @word.category]
    else
      flash.now[:danger] = t :create_word_fail_mess
      render :new
    end
  end

  def edit
  end

  def update
    if @word.update_attributes word_params
      flash[:success] = t :update_word_success_mess
      redirect_to admin_category_path @word.category.id
    else
      flash.now[:danger] = t :update_word_fail_mess
      render :edit
    end
  end

  def destroy
    if @word.results.any?
      flash[:danger] = t :cant_destroy_word
    elsif @word.destroy
      flash[:success] = t :word_delete_success_mess
    else
      flash[:danger] = t :word_delete_fail_mess
    end
    redirect_to [:admin, @word.category]
  end

  private
  def word_params
    params.require(:word).permit :content, :category_id,
      answers_attributes: [:id, :content, :is_correct, :_destroy]
  end

  def load_word
    @word = Word.find_by id: params[:id]
    if @word.nil?
      flash[:danger] = t :word_nil_mess
      redirect_to admin_category_path
    end
  end
end
