class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post }
        format.turbo_stream
      end
    else
      flash[:error] = "Failed to add comment."
      render "posts/show"
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @post }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_post
    @post = Post.find(params[:post_id])
    p @post
  end
end
