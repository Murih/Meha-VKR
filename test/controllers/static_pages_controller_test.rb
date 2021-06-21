require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Meha"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Помощь | Meha"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "О проекте | Meha"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Поддержка | Meha"
  end
end
