class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by_id(params[:id])
  end


  def create
    @user = User.find(params[:article_id])
    @class = Course.find(params[:article_id])
    @post = Post.create(post_params)
    redirect_to article_path(@article)
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end


  # def edit
  #   @post = Post.find(params[:id])
  # end
  #
  # def update
  #   @post = Post.find(params[:id])
  #
  #   if @post.update(Post_params)
  #     redirect_to @post
  #   else
  #     render :edit, status: :unprocessable_entity
  #
  #   end
  # end
  #
  # def destroy
  #   # logger.info "Processing the request... "
  #   @post = Post.find(params[:id])
  #   @post.destroy
  #
  #   redirect_to root_path, status: :see_other
  # end
  #


end
