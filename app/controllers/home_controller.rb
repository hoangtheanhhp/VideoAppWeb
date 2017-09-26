class HomeController < ApplicationController
  before_action :logged_in_user, only: [:ajax]
  def show
    if logged_in?
      @videos = Video.all
      @video = current_user.videos.build
    end
  end

  def ajax
    case params[:selectNum]
      when "2"
        time = Time.zone.now.beginning_of_day..Time.zone.now.end_of_week
      when "3"
        time = Time.zone.now.beginning_of_week..Time.zone.now.end_of_week
      when "4"
        time = Time.zone.now.beginning_of_month..Time.zone.now.end_of_month
      else
        time = Time.zone.now.beginning_of_year..Time.zone.now.end_of_year
    end
    if params[:selectNum]!="1"
      @videos = Video.where(:created_at => time).all
    else
      @videos = Video.all
    end
    render @videos
  end
end
