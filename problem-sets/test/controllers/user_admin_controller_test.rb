require 'test_helper'

class UserAdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_admin_index_url
    assert_response :success
  end

end
