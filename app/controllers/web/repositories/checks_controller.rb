# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  include Pundit::Authorization

  before_action :authenticate_user!

  def create
    @repository = current_user.repositories.find(params[:repository_id])
    @check = @repository.checks.create
    authorize @check

    RepositoryCheckerJob.perform_later(@check.id)
    redirect_to repository_path(@repository), notice: t('.check_started')
  end

  def show
    @repository = current_user.repositories.find(params[:repository_id])
    @check = @repository.checks.find(params[:id])
    authorize @check
    @issues = @check.parsed_issues
  end
end
