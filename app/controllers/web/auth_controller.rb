module Web
  class AuthController < ApplicationController
    def callback
      @user = User.find_or_initialize_by(email: user_params[:email])
      @user.nickname = user_params[:nickname]
      @user.token = user_params[:token]

      if @user.save
        create_session(@user)
        redirect_to root_path, notice: t('.signed_in')
      else
        redirect_to root_path, alert: t('.cant_sign_in')
      end
    end

    def sign_out
      destroy_session
      redirect_to root_path, notice: t('.signed_out')
    end
    
    private

    def user_params
      user_info = request.env['omniauth.auth']
      {
        email: user_info[:info][:email],
        nickname: user_info[:info][:nickname] || user_info[:info][:name],
        token: user_info[:credentials][:token]
      }
    end
  end
end