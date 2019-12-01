# require 'test_helper'
#
# class NeedsControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @need = needs(:one)
#   end
#
#   test "should get index" do
#     get needs_url
#     assert_response :success
#   end
#
#   test "should get new" do
#     get new_need_url
#     assert_response :success
#   end
#
#   test "should create need" do
#     assert_difference('Need.count') do
#       post needs_url, params: { need: { group_id: @need.group_id, item_id: @need.item_id, quantity: @need.quantity, user_id: @need.user_id } }
#     end
#
#     assert_redirected_to need_url(Need.last)
#   end
#
#   test "should show need" do
#     get need_url(@need)
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get edit_need_url(@need)
#     assert_response :success
#   end
#
#   test "should update need" do
#     patch need_url(@need), params: { need: { group_id: @need.group_id, item_id: @need.item_id, quantity: @need.quantity, user_id: @need.user_id } }
#     assert_redirected_to need_url(@need)
#   end
#
#   test "should destroy need" do
#     assert_difference('Need.count', -1) do
#       delete need_url(@need)
#     end
#
#     assert_redirected_to needs_url
#   end
# end
