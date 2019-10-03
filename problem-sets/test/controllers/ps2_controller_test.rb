require 'test_helper'

class Ps2ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ps2_index_url
    assert_response :success
  end

end
