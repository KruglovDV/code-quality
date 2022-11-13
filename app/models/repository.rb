# frozen_string_literal: true

class Repository < ApplicationRecord
  include AASM
  extend Enumerize

  belongs_to :user
  has_many :checks, class_name: 'Repository::Check', dependent: :destroy

  validates :github_id, presence: true, uniqueness: true
  enumerize :language, in: %i[JavaScript Ruby]

  aasm do
    state :created, initial: true
    state :fetching, :fetched, :fetch_failed

    event :fetch do
      transitions from: :created, to: :fetching
    end

    event :fail do
      transitions from: :fetching, to: :fetch_failed
    end

    event :success do
      transitions from: :fetching, to: :fetched
    end
  end
end
