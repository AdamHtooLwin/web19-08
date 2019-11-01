require 'test_helper'

class UserAdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:two)
    @banned_user = users(:banned)
  end

  test "should get index" do
    sign_in users(:one)
    get user_admin_index_url
    assert_response :success
  end

  test "should redirect if not admin" do
    sign_in users(:two)
    get user_admin_index_url
    assert_response :redirect
  end

  test "should redirect if not signed in" do
    sign_in users(:two)
    get user_admin_index_url
    assert_response :redirect
  end

  test "should ban user" do
    sign_in users(:one)
    patch user_admin_ban_user_url, params: { user_id: @banned_user.id }
    assert_redirected_to user_admin_index_url

    assert_response :redirect
  end

  test "should update avatar" do
    sign_in users(:two)

    post profile_update_avatar_url, params: { avatar: nil, id: @user.id}
    assert_redirected_to profile_show_url

    assert_response :redirect
  end

  test "should update profile" do
    sign_in users(:two)

    post profile_update_url, params: { first_name: "Boris", last_name: "Johnson", "email": "boris@uk.org", id: @user.id}
    assert_redirected_to profile_show_url

    assert_response :redirect
  end

end
