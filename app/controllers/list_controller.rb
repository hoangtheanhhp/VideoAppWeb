class ListController < ApplicationController
  before_action :admin_user , only: [:index]
  def index
    if session[:list].nil?
      session[:list]=Array.new
    end
    @list = Array.new
    session[:list].each do |id|
      puts id
      @list.push Video.find_by uid: id
    end
  end
end
