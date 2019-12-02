require 'test_helper'

class NeedsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @need = needs(:one)
    @group = groups(:one)
  end

  test "should resolve need" do
    post resolve_needs_url(params: { id: @group.id })
    assert_redirected_to group_url(@group, params: { notice: "The needs were successfully resolved" })
  end

  test "should get index" do
    get needs_url
    assert_response :success
  end

  test "should get new" do
    get new_need_url
    assert_response :success
  end

  test "should create need" do
    sign_in users(:one)

    assert_difference('Need.count') do
      post needs_url, params: { need: { group_id: 1, item_id: "Coke", quantity: 5, user_id: 2 } }
    end

    assert_redirected_to group_url(@group, params: { notice: "Need was successfully created."})
  end

  test "should create duplicate and sum need" do
    sign_in users(:one)

    assert_difference('Need.count', 0) do
      post needs_url, params: { need: { group_id: 1, item_id: "Coke", quantity: 5, user_id: 1 } }
    end

    assert_redirected_to group_url(@group)
  end

  test "should not create need" do
    sign_in users(:one)

    assert_difference('Need.count', 0) do
      post needs_url, params: { need: { group_id: 1, item_id: "Coke", quantity: "", user_id: 1 } }
    end

    assert_redirected_to group_url(@group)
  end

  test "should show need" do
    get need_url(@need)
    assert_response :success
  end

  test "should get edit" do
    get edit_need_url(@need)
    assert_response :success
  end

  test "should update need" do
    sign_in users(:one)

    patch need_url(@need), params: { need: { group_id: "1", item_id: "2", quantity: @need.quantity, user_id: "4" } }
    assert_response :redirect
  end

  test "should destroy need" do
    assert_difference('Need.count', -1) do
      delete need_url(@need, params: { group_id: 1})
    end

    assert_redirected_to group_url(@group, params: { notice: "Need was successfully destroyed."})
  end
end
