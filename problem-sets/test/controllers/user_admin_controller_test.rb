require 'test_helper'

class UserAdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    sign_in users(:two)
    get user_admin_index_url
    assert_response :success
  end

end
