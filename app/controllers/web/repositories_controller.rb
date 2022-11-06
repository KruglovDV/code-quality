# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories.order('updated_at DESC').includes(:checks)
      @repositories_last_checks = @repositories.each_with_object({}) do |repo, acc|
        acc[repo.id] = repo.checks.order('created_at DESC').first
      end
    end

    def new
      @repository = Repository.new
      @repositories_collection = repositories_collection
    end

    def create
      @repository = current_user.repositories.build(repository_params)

      if @repository.save
        @check = @repository.checks.create
        RepositoryCheckerJob.perform_later(@check.id)
        SetWebHookJob.perform_later(@repository.id)
        redirect_to repositories_path, notice: t('.repository_created')
      else
        @repositories_collection = repositories_collection
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @repository = current_user.repositories.find(params[:id])
      @checks = @repository.checks.order('created_at DESC')
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def repositories_collection
      user_repositories = current_user.user_repositories.filter do |repo|
        Repository.language.find_value repo[:language]
      end
      user_repositories.map { |repo| [repo[:full_name], repo[:id]] }
    end
  end
end
