class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by_id(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    course_id = params[:course_id]

    @post = Post.new(user_id: @current_user.id, course_id: course_id,
                        title: post_params[:title], body: post_params[:body])

    if @post.save
      redirect_to controller: 'posts', action: 'show', id: @post.id
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def post_params
    params.require(:post).permit(:course_id, :title, :body)
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
