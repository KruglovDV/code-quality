# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
    end

    def new
      @repository = Repository.new
      client = ::Octokit::Client.new access_token: current_user.token, auto_paginate: true
      @user_repositories = client.repos
    end

    def create
      @repository = current_user.repositories.build(repository_params)

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
  end
end
