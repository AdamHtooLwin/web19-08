require 'test_helper'

class SiteControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    sign_in users(:one)

    get site_index_url
    assert_response :success
  end

end
