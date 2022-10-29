# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  def check
    @repository = Repository.find_by(full_name: params[:repository][:full_name])
    @check = @repository.checks.create
    RepositoryCheckerJob.perform_later(@check.id)
    render json: {}
  end
end
