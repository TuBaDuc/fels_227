class FollowersController < UsersController
  before_action :load_user, only: [:index]

  def index
    @title = t(:followers_text).capitalize
    @users = @user.followers.order(name: :desc)
      .paginate page: params[:page], per_page: Settings.follow_entry_per_page
    render "show_follow"
  end

end
