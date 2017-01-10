class FollowingController < UsersController
  before_action :load_user, only: [:index]

  def index
    @title = t(:following_text).capitalize
    @users = @user.following.paginate page: params[:page]
    render "show_follow"
  end

end
