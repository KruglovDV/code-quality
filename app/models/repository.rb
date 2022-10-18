# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, class_name: 'Repository::Check', dependent: :destroy

  validates :name, presence: true
  enumerize :language, in: %i[JavaScript], default: :JavaScript
end
