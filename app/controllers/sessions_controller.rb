class SessionsController < ApplicationController
  before_action :logged_in_user, only: [:addmusic, :push, :drop]
  def create
    #puts request.env["omniauth.auth"].to_json, 'aaaaaaaaaaaaaaaaaaa'
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    session[:list] = Array.new
    flash[:success] = "Hello #{user.name}"
    if User.all.count == 1
      user.toggle!(:admin);
    end
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success]= "Goodbye!"
    redirect_to root_path
  end

  def push
    if session[:list].nil?
      session[:list] = Array.new
    end
    if !session[:list].include? params[:videouid]
      session[:list].unshift params[:videouid]
    end
    redirect_to root_url
  end

  def drop
    if session[:list].nil?
      session[:list] = Array.new
    end
    if session[:list].include? params[:videouid]
      session[:list].delete params[:videouid]
    end
    redirect_to root_url
  end

end
