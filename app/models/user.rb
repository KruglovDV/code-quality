# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :email, presence: true

  def user_repositories
    Rails.cache.fetch("#{cache_key_with_version}/user_repositories", expires_in: 10.minutes) do
      client = ApplicationContainer[:github_client].new access_token: token, auto_paginate: true
      client.repos
    end
  end
end
