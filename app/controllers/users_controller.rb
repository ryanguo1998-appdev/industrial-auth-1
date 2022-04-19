class UsersController < ApplicationController
  before_action :set_user, only: %i[ show liked feed followers following discover ]
  before_action :ensure_user_is_follower, only: %i[ liked ]
  before_action :ensure_user_is_current_user, only: %i[ feed discover ]

  def ensure_user_is_follower
    if @user.followers.exclude? current_user
      p "got here #{current_user.inspect}"
      redirect_back fallback_location: user_path(@user.username), alert: "Sending you back" 
    end
  end

  def ensure_user_is_current_user
    if @user != current_user
      redirect_back fallback_location: root_path, alert: "You can't do that"
    end
  end

  private

    def set_user
      if params[:username]
        @user = User.find_by!(username: params.fetch(:username))
        p @user
      else
        @user = current_user
      end
    end
end