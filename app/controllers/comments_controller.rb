class CommentsController < ApplicationController
  def post_comments
    @micropost = Micropost.find_by(id: params[:micropost_id])
    @comments = @micropost.comments

    respond_to do |format|
      format.html { redirect_to @micropost }
      format.js
    end
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'Комментарий добавлен'
    else
      flash[:danger] = 'Слишком длинный комментарий'
    end
    redirect_to root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :micropost_id)
  end
end