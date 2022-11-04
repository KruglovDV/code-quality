# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  helper_method :signed_in?, :current_user

  include Auth
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :deny_access
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def deny_access
    redirect_to root_path, alert: t('common.access_denied')
  end

  def not_found
    redirect_to root_path, alert: t('common.not_found')
  end

  def resource_repo
    current_user.repositories.find(params[:repository_id])
  end
end
