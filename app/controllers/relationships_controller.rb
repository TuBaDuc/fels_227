class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find params[:followed_id]
    unless current_user.following?(@user)
      current_user.follow @user
      add_activity Activity.action_types[:follow] ,@user
    end
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow @user
    add_activity Activity.action_types[:unfollow] , @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
