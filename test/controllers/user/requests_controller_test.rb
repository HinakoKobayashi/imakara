require "test_helper"

class User::RequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_requests_new_url
    assert_response :success
  end
end
