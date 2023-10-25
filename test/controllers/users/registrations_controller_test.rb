require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'creates a user with an associated organization' do
    assert_difference('User.count') do
      post user_registration_path, params: {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          organization_name: 'putit'
        }
      }
    end

    user = User.last
    organization = Organization.find_by(name: 'putit')

    assert_equal organization, user.organization
  end

  test 'generates an organization name based on email if not provided' do
    assert_difference('User.count') do
      post user_registration_path, params: {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    user = User.last
    expected_organization_name = Base64.strict_encode64('test@example.com')
    organization = Organization.find_by(name: expected_organization_name)

    assert_equal organization, user.organization
  end
end
