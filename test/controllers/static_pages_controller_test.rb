require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get hoe" do
    get :hoe
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

end
