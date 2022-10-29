# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def check_failed_email
    @check = params[:check]
    @repository = @check.repository
    @user = @repository.user
    puts @check
    puts @repository
    puts @user
    mail(to: @user.email, subject: t('.subject'))
  end
end
