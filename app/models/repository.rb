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
    state :loading, :loaded_from_github, :load_failed

    event :load do
      transitions from: :created, to: :loading
    end

    event :fail do
      transitions from: :loading, to: :load_failed
    end

    event :success do
      transitions from: :loading, to: :loaded_from_github
    end
  end
end
