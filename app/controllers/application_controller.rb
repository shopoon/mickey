class ApplicationController < ActionController::Base
  require "pp"
  before_filter :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  PER_PAGE = 20

  def super_admin_user?
    if current_user
      return current_user.role.super_admin?
    end
    false
  end

  def admin_user?
    if current_user
      return current_user.role.admin? || current.user.role.super_admin?
    end
    false
  end
    
  def set_since
    if params[:since].blank?
      @since = Date.today - 1.month
    else
      @since = Date.parse(params[:since])
    end
  end

  def set_until
    if params[:until].blank?
      @until = Date.today
    else
      @until = Date.parse(params[:until])
    end
  end
end
