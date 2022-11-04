# frozen_string_literal: true

class SetWebHookJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    @repository = Repository.find_by(id: repository_id)
    return if @repository.nil?

    client = ApplicationContainer[:github_client].new(access_token: @repository.user.token, auto_paginate: true)
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
