require 'test_helper'

class OwnershipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ownerships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ownership" do
    assert_difference('Ownership.count') do
      post :create, :ownership => { }
    end

    assert_redirected_to ownership_path(assigns(:ownership))
  end

  test "should show ownership" do
    get :show, :id => ownerships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ownerships(:one).to_param
    assert_response :success
  end

  test "should update ownership" do
    put :update, :id => ownerships(:one).to_param, :ownership => { }
    assert_redirected_to ownership_path(assigns(:ownership))
  end

  test "should destroy ownership" do
    assert_difference('Ownership.count', -1) do
      delete :destroy, :id => ownerships(:one).to_param
    end

    assert_redirected_to ownerships_path
  end
end
