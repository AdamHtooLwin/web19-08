require 'test_helper'

class BasicsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get basics_index_url
    assert_response :success
  end

end
