# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :nickname, :token, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def user_repositories
    Rails.cache.fetch("#{cache_key_with_version}/user_repositories", expires_in: 10.minutes) do
      client = ::Octokit::Client.new access_token: token, auto_paginate: true
      client.repos
    end
  end
end
