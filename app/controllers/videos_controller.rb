class VideosController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :admin_user, only: [:ban, :show]
  before_action :correct_user, only: [:destroy]

  def index
    @videos = Video.order('created_at DESC')
  end

  def new
    @video = current_user.videos.build
  end

  def create
    @video = current_user.videos.build(video_params)
    if @video.save
      flash[:success] = 'Video added!'
      if !session[:list].include? @video.uid
        session[:list].unshift @video.uid
      end
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    video = Video.find(params[:id])
    if session[:list].include? video.uid
      session[:list].delete video.uid
    end
    video.destroy
    flash[:success] = "A video is deleted!"
    redirect_to root_url
  end

  def ban
    @@music = Video.find(params[:id])
    @@music.toggle!(:banned)
    flash[:success] = "#{@@music.user.name}'s #{@@music.link} is banned"
  end

  private

  def video_params
    params.require(:video).permit(:link)
  end
  def correct_user
    redirect_to root_url unless current_user? Video.find(params[:id]).user
  end
end
