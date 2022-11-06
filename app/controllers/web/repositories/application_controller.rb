# frozen_string_literal: true

class Web::Repositories::ApplicationController < Web::ApplicationController
  def resource_repo
    current_user.repositories.find(params[:repository_id])
  end
end
