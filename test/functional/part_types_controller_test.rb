require 'test_helper'

class PartTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:part_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create part_type" do
    assert_difference('PartType.count') do
      post :create, :part_type => { }
    end

    assert_redirected_to part_type_path(assigns(:part_type))
  end

  test "should show part_type" do
    get :show, :id => part_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => part_types(:one).to_param
    assert_response :success
  end

  test "should update part_type" do
    put :update, :id => part_types(:one).to_param, :part_type => { }
    assert_redirected_to part_type_path(assigns(:part_type))
  end

  test "should destroy part_type" do
    assert_difference('PartType.count', -1) do
      delete :destroy, :id => part_types(:one).to_param
    end

    assert_redirected_to part_types_path
  end
end
