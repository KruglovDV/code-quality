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
      @user_repositories = user_github_repositories
      @repositories_collection = repositories_collection(@user_repositories)
    end

    def create
      @repository = current_user.repositories.build(repository_params)

      if @repository.save
        @check = @repository.checks.create
        RepositoryCheckerJob.perform_later(@check.id)
        SetWebHookJob.perform_later(@repository.id)
        redirect_to repositories_path, notice: t('.repository_created')
      else
        @user_repositories = user_github_repositories
        @repositories_collection = repositories_collection(@user_repositories)
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @repository = Repository.find(params[:id])
      authorize @repository
      @checks = @repository.checks.order('created_at DESC')
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def user_github_repositories
      current_user.user_repositories.filter do |repo|
        Repository.language.find_value repo[:language]
      end
    end

    def repositories_collection(repositories)
      repositories.map { |repo| [repo[:full_name], repo[:id]] }
    end
  end
end
