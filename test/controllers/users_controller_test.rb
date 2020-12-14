require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get image" do
    get users_image_url
    assert_response :success
  end

end
