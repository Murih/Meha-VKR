class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Пост опубликован!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Пост удален"
    redirect_to request.referrer || root_url
  end
  def post_comments
    @micropost = Micropost.find_by(id: params[:micropost_id])
    @comments = @micropost.comments
  end
  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end