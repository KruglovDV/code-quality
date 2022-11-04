# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm do
    state :created, initial: true
    state :checking, :failed, :finished

    event :check do
      transitions from: :created, to: :checking
    end

    event :fail do
      transitions from: :checking, to: :failed
    end

    event :success do
      transitions from: :checking, to: :finished
    end
  end
end
