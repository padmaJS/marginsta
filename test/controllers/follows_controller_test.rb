require "test_helper"

class FollowsControllerTest < ActionDispatch::IntegrationTest
  test "should get follow_user" do
    get follows_follow_user_url
    assert_response :success
  end

  test "should get unfollow_user" do
    get follows_unfollow_user_url
    assert_response :success
  end
end
