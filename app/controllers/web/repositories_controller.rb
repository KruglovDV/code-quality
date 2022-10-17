# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
    end

    def new
      @repository = Repository.new
      @user_repositories = user_repositories
    end

    def create
      @current_repository = user_repositories.find do |repo|
        repo[:full_name] == repository_params[:name]
      end

      if @current_repository.nil?
        return redirect_to new_repository_path, alert: t('.repository_not_found')
      end

      @repository = current_user.repositories.build({
                                                      name: @current_repository[:name],
                                                      language: @current_repository[:language]
                                                    })

      if @repository.save
        redirect_to repositories_path, notice: t('.repository_created')
      else
        redirect_to new_repository_path, alert: t('.repository_name_required')
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:name)
    end

    def user_repositories
      current_user.user_repositories.filter do |repo|
        Repository.language.values.include? repo[:language]
      end
    end
  end
end
