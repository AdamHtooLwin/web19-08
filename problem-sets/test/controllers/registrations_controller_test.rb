require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should be able to sign up" do

    assert_difference('User.count') do
      post user_registration_url, params: { user: { first_name: "Donald", last_name: "Trump", email: "donald@a.com", password: "password" } }
    end

    assert_response :redirect
  end

  test "should be banned" do
    sign_in users(:banned)
    get documentation_index_url
    assert_response :redirect
  end
end
