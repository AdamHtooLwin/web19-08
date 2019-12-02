require 'test_helper'

class Ps1ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ps1_index_url
    assert_response :success
  end

  test "should get divide_by_zero" do
    get ps1_divide_by_zero_url
    assert_response :success
  end

  test "should get scrapper" do
    get ps1_scrapper_url
    assert_response :success
  end

end
