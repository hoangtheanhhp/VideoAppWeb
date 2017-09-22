class UsersController < ApplicationController
  before_action :admin_user, only: [:destroy, :active, :list]
  before_action :logged_in_user, only: [:show, :index]


  def show
    @user = User.find(params[:id])
    @videos = @user.videos.paginate(page: params[:page],per_page: 5)
    if current_user == @user && logged_in?
            @video = @user.videos.build
            #@time = current_user.videos.build

    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def active
    user = User.find(params[:id])
    user.toggle!(:admin)
    redirect_to users_path
  end


end
