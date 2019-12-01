require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @group = groups(:one)
  end

  test "should get index" do
    sign_in users(:two)

    get groups_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:two)

    get new_group_url
    assert_response :success
  end

  test "should create group" do
    sign_in users(:two)

    assert_difference('Group.count') do
      post groups_url, params: { group: { user_id: @group.user_id, name: @group.name } }
    end

    assert_redirected_to group_url(Group.last)
  end

  test "should show group" do
    sign_in users(:two)

    get group_url(@group)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:one)

    get edit_group_url(@group)
    assert_response :success
  end

  test "should update group" do
    sign_in users(:one)

    patch group_url(@group), params: { group: { user_id: @group.user_id, name: @group.name } }
    assert_redirected_to group_url(@group)
  end

  test "should destroy group" do
    sign_in users(:one)

    assert_difference('Group.count', -1) do
      delete group_url(@group)
    end

    assert_redirected_to root_path
  end
end
