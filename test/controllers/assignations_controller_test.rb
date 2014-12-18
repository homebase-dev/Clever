require 'test_helper'

class AssignationsControllerTest < ActionController::TestCase
  setup do
    @assignation = assignations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignation" do
    assert_difference('Assignation.count') do
      post :create, assignation: { question_id: @assignation.question_id, test_id: @assignation.test_id }
    end

    assert_redirected_to assignation_path(assigns(:assignation))
  end

  test "should show assignation" do
    get :show, id: @assignation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assignation
    assert_response :success
  end

  test "should update assignation" do
    patch :update, id: @assignation, assignation: { question_id: @assignation.question_id, test_id: @assignation.test_id }
    assert_redirected_to assignation_path(assigns(:assignation))
  end

  test "should destroy assignation" do
    assert_difference('Assignation.count', -1) do
      delete :destroy, id: @assignation
    end

    assert_redirected_to assignations_path
  end
end
