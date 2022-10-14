# frozen_string_literal: true

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth' do
    post auth_request_path('github')
    assert_response :redirect
  end

  test 'create' do
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: Faker::Internet.email,
        nickname: Faker::Name.first_name
      },
      credentials: {
        token: 'token'
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
    assert_response :redirect

    user = User.find_by!(email: auth_hash[:info][:email].downcase)

    assert user
    assert signed_in?
  end

  test 'sign out' do
    sign_in(users(:john))
    delete sign_out_path
    assert session[:user_id].nil?
    assert_redirected_to root_path
  end
end
