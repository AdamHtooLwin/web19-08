require 'test_helper'

class UserGroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user_group = user_groups(:one)
    @group = groups(:one)
  end

  test "should leave group" do
    sign_in users(:one)

    delete leave_group_url(params: { id: @user_group.id })
    assert_redirected_to root_url
  end

  test "should get index" do
    get user_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_user_group_url
    assert_response :success
  end

  test "should create user_group" do
    assert_difference('UserGroup.count') do
      post user_groups_url, params: { user_group: { group_id: 1, user_id: 1 } }
    end

    assert_redirected_to user_group_url(UserGroup.last)
  end

  test "should show user_group" do
    get user_group_url(@user_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_group_url(@user_group)
    assert_response :success
  end

  test "should update user_group" do
    sign_in users(:one)

    patch user_group_url(@user_group), params: { user_group: { group_id: @user_group.group_id, user_id: @user_group.user_id } }
    assert_redirected_to user_group_url(@user_group)
  end

  test "should destroy user_group" do
    assert_difference('UserGroup.count', -1) do
      delete user_group_url(@user_group)
    end

    assert_redirected_to group_url(@group, notice: "User was successfully removed from the group.")
  end
end
