class FollowersController < UsersController
  before_action :load_user, only: [:index]

  def index
    @title = t(:followers_text).capitalize
    @users = @user.followers.paginate page: params[:page]
    render "show_follow"
  end

end
