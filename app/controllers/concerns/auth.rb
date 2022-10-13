# frozen_string_literal: true

module Auth
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def create_session(user)
    session[:user_id] = user.id
  end

  def destroy_session
    session[:user_id] = nil
  end

  def authenticate_user!
    redirect_to root_path, alert: t('.please_sign_in') if current_user.nil?
  end
end
