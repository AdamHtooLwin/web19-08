require 'test_helper'

class ProfileControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get show" do
    sign_in users(:two)
    get profile_show_url
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:two)
    get profile_edit_url
    assert_response :success
  end

end
