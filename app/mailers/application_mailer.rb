# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('BASE_URL', '')
  layout 'mailer'
end
