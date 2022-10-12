class User < ApplicationRecord
  validates :nickname, :token, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
end
