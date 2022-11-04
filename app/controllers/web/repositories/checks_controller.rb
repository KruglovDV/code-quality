# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  before_action :authenticate_user!

  def create
    @repository = resource_repo
    @check = @repository.checks.create
    RepositoryCheckerJob.perform_later(@check.id)
    redirect_to repository_path(@repository), notice: t('.check_started')
  end

  def show
    @repository = resource_repo
    @check = @repository.checks.find(params[:id])
    @issues = parse_issues(@check.issues)
    @issues_count = @issues.reduce(0) { |sum, file| sum + file['issues'].count }
  end

  private

  def parse_issues(issues)
    return [] if issues.nil?

    JSON.parse(issues)
  end
end
