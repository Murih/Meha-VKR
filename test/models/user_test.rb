require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@sfedu.ru",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 247 + "@sfedu.ru"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@sfedu.ru USER@sfedu.ru A_US-ER@sfedu.ru
                         first.last@sfedu.ru alice+bob@sfedu.ru]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@sfedu,ru user_at_foo.ru user.name@sfedu.
                           foo@sfedu.com foo@sfeduru]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    katty = users(:katty)
    archer  = users(:archer)
    assert_not katty.following?(archer)
    katty.follow(archer)
    assert katty.following?(archer)
    assert archer.followers.include?(katty)
    katty.unfollow(archer)
    assert_not katty.following?(archer)
  end

  test "feed should have the right posts" do
    katty = users(:katty)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert katty.feed.include?(post_following)
    end
    # Posts from self
    katty.microposts.each do |post_self|
      assert katty.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not katty.feed.include?(post_unfollowed)
    end
  end
end