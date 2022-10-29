# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm do
    state :created, initial: true
    state :checking, :failed, :succeeded

    event :check do
      transitions from: :created, to: :checking
    end

    event :fail do
      transitions from: :checking, to: :failed
    end

    event :success do
      transitions from: :checking, to: :succeeded
    end
  end

  def parsed_issues
    return [] if self[:issues].nil?

    JSON.parse(self[:issues])
  end
end
