class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by_id(params[:id]) or not_found
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(Post_params)

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(Post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity

    end
  end

  def destroy
    # logger.info "Processing the request... "
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path, status: :see_other
  end


  private
  def Post_params
    params.require(:Post).permit(:name, :Post_name, :email)
  end


end
