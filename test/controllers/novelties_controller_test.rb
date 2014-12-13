require 'test_helper'

class NoveltiesControllerTest < ActionController::TestCase
  setup do
    @novelty = novelties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:novelties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create novelty" do
    assert_difference('Novelty.count') do
      post :create, novelty: { priority: @novelty.priority, published: @novelty.published, text: @novelty.text, title: @novelty.title }
    end

    assert_redirected_to novelty_path(assigns(:novelty))
  end

  test "should show novelty" do
    get :show, id: @novelty
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @novelty
    assert_response :success
  end

  test "should update novelty" do
    patch :update, id: @novelty, novelty: { priority: @novelty.priority, published: @novelty.published, text: @novelty.text, title: @novelty.title }
    assert_redirected_to novelty_path(assigns(:novelty))
  end

  test "should destroy novelty" do
    assert_difference('Novelty.count', -1) do
      delete :destroy, id: @novelty
    end

    assert_redirected_to novelties_path
  end
end
