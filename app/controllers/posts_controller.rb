class PostsController < AuthenticatedController


  before_action :set_post, only: %i[ show edit update destroy ]

  def set_post
    @post = Post.find(params[:id])
    @course = Course.find(@post.course_id)
  end

  def index
    @posts = Post.all
  end

  def show

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
    # @post = Post.find_by(id: params[:id])
  end

  def update
    # @post = Post.find_by(id: params[:id])
    if @post.update(post_params)
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
