class ListController < ApplicationController
  before_action :admin_user , only: [:index]
  before_action :play , only: [:index]
  def index
    @list = Array.new
    session[:list].each do |id|
      @list.push Video.find_by uid: id
    end
    @next_video_index = (params[:index].to_i+1) % @list.length
  end
  private
    def play
      if session[:list].length == 0
        flash[:danger] = "Play list is empty!"
        redirect_to root_url
      end
    end
end
