module MicropostsHelper
  def check_like(news)
    @user_like = Like.left_joins(:user, :news).where(users: {id: current_user.id}, news: {id: news.id}).take
  end
end
