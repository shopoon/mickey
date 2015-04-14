module ApplicationHelper
  def super_admin_user?
    if current_user
      return current_user.role.super_admin?
    end
    false
  end

  def admin_user?
    if current_user
      return current_user.role.admin? || current_user.role.super_admin?
    end
    false
  end

  def flash_class(level)
    case level
    when :notice then "info"
    when :error then "error"
    when :alert then "warning"
    end
  end
end
