# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  def create
    @repository = Repository.find_by(full_name: params[:repository][:full_name])

    return render(json: {}, status: :not_found) if @repository.nil?

    @check = @repository.checks.create
    RepositoryCheckerJob.perform_later(@check.id)
    render json: {}
  end
end
