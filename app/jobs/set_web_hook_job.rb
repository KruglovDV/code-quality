# frozen_string_literal: true

class SetWebHookJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    @repository = Repository.find(repository_id)
    client = ApplicationContainer[:github_client].new(access_token: @repository.user.token, auto_paginate: true)
    client.create_hook(
      @repository.full_name,
      'web',
      {
        url: "https://#{ENV.fetch('BASE_URL', '')}#{Rails.application.routes.url_helpers.check_path}",
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end
end
