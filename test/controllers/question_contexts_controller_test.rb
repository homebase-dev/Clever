require 'test_helper'

class QuestionContextsControllerTest < ActionController::TestCase
  setup do
    @question_context = question_contexts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:question_contexts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create question_context" do
    assert_difference('QuestionContext.count') do
      post :create, question_context: { category_id: @question_context.category_id, content: @question_context.content, creator_id: @question_context.creator_id, published: @question_context.published }
    end

    assert_redirected_to question_context_path(assigns(:question_context))
  end

  test "should show question_context" do
    get :show, id: @question_context
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @question_context
    assert_response :success
  end

  test "should update question_context" do
    patch :update, id: @question_context, question_context: { category_id: @question_context.category_id, content: @question_context.content, creator_id: @question_context.creator_id, published: @question_context.published }
    assert_redirected_to question_context_path(assigns(:question_context))
  end

  test "should destroy question_context" do
    assert_difference('QuestionContext.count', -1) do
      delete :destroy, id: @question_context
    end

    assert_redirected_to question_contexts_path
  end
end
