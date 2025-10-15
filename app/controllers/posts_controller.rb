class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, except: [:index]
  before_action :authorize_post_owner, only: [:edit, :update, :destroy]

  def index
    @pagy, @posts = pagy(Post.order(created_at: :desc), items: 5)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "Post updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: "Post deleted successfully."
  end

  def likers
    @likers = @post.likes.includes(:user).map(&:user)
    render layout: false
  end

  private

  def post_params
    params.require(:post).permit(:caption, :image)
  end

  def set_post
    @post = Post.find(params[:id] || params[:post_id])
    unless @post
      redirect_to root_path, alert: "Post not found." and return
    end
  end

  def authorize_post_owner
    redirect_to post_path(@post), alert: "You are not authorized to perform this action." unless @post.user == current_user
  end
end
