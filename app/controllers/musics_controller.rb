class MusicsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :admin_user, only: [:ban, :show]
  before_action :correct_user, only: [:destroy]


  def show
    @music = Music.find(params[:id])
  end

  def create
    @music = current_user.musics.build(music_params)
    @music.link = @music.link.split("=").last
    if @music.save
      flash[:success] = "A Music is added!"
      redirect_to root_url
    else
      redirect_to root_url
    end
  end

  def ban
    @@music = Music.find(params[:id])
    @@music.toggle!(:banned)
    flash[:success] = "#{@@music.user.name}'s #{@@music.link} is banned"
    redirect_to root_url
  end

  def destroy
    Music.find(params[:id]).destroy
    flash[:success] = "A link is deleted!"
    redirect_to root_url
  end

  private
    def music_params
      params.require(:music).permit(:link)
    end
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
    def correct_user
      redirect_to root_url unless current_user?(Music.find(params[:id]).user)
    end
end
