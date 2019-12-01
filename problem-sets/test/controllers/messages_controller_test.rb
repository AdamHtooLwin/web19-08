require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @message = messages(:one)
    @group = groups(:one)
  end

  test "should get index" do
    get messages_url
    assert_response :success
  end

  test "should get new" do
    get new_message_url
    assert_response :success
  end

  test "should create message" do
    sign_in users(:two)

    assert_difference('Message.count') do
      post messages_url, params: { message: { group_id: @group.id, content: @message.content, user_id: @message.user_id } }
    end

    assert_redirected_to group_url(@group)
  end

  test "should show message" do
    get message_url(@message)
    assert_response :success
  end

  test "should get edit" do
    get edit_message_url(@message)
    assert_response :success
  end

  # test "should update message" do
  #   sign_in users(:one)
  #
  #   patch message_url(@message), params: { message: { content: "Something"} }
  #   assert_redirected_to message_url(@message)
  # end

  test "should destroy message" do
    assert_difference('Message.count', -1) do
      delete message_url(@message)
    end

    assert_redirected_to messages_url
  end
end
