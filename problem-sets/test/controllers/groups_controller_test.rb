require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @group = groups(:one)
    @user = users(:two)
    @group2 = groups(:two)
  end

  test "should fail to edit group as non group admin" do
    sign_in users(:two)

    get edit_group_url(@group2)

    assert_response :redirect
  end

  test "should lock group" do
    sign_in users(:one)

    post lock_group_url(params: { id: @group.id })

    assert_response :redirect
  end

  test "should unlock group" do
    sign_in users(:one)

    post unlock_group_url(params: { id: @group.id })

    assert_response :redirect
  end

  test "get add users path" do
    sign_in users(:one)

    get add_users_url, params: { q: @user.id , search_user: "2", group_id: @group.id }

    assert_response :redirect
  end

  test "get users path" do
    sign_in users(:one)

    get get_users_url, params: { name: "" , search_user: "1"}
  end

  test "should create a group using get users" do
    sign_in users(:one)

    get get_users_url, params: { name: "SV67", search_user: 1 }

    assert_response :redirect
  end

  test "should fail to create groups" do
    sign_in users(:one)

    assert_difference('Group.count', 0) do
      post groups_url, params: { group: { user_id: @group.user_id } }
    end
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
