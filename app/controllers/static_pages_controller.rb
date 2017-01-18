class StaticPagesController < ApplicationController
  def home
    unless current_user.nil?
      @activities = Activity.feed_activities(current_user.id)
        .order(created_at: :desc).paginate page: params[:page],
          per_page: Settings.home_activities_limit
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
