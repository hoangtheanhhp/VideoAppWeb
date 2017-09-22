module SessionsHelper
  def logged_in?
    !current_user.nil?
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please login!"
      redirect_to root_url
    end
  end

  def current_user?(user)
    user == current_user
  end

  def admin_user
    unless current_user.admin?
    flash[:info] = "Sorry! You aren't admin"
    redirect_to root_url
      end
  end

end
