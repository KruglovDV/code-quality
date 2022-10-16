# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user

  validates :name, presence: true

  enumerize :language, in: %i[javascript], default: :javascript
end
