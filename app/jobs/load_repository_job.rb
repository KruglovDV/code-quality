# frozen_string_literal: true

class LoadRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    @repository = Repository.find_by(id: repository_id)
    return if @repository.nil?

    client = ApplicationContainer[:github_client].new(access_token: @repository.user.token, auto_paginate: true)
    @repository.load!
    begin
      @repository_info = client.repository(@repository.github_id)
      @repository.update(
        name: @repository_info[:name],
        full_name: @repository_info[:full_name],
        language: @repository_info[:language],
        clone_url: @repository_info[:clone_url]
      )
      @repository.success!
    rescue StandardError => e
      Rails.logger.fatal(e)
      @repository.fail!
      return
    end

    client.create_hook(
      @repository.full_name,
      'web',
      {
        url: Rails.application.routes.url_helpers.api_checks_url,
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end
end
