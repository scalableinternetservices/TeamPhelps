class PostsController < AuthenticatedController


  before_action :set_post, only: %i[ show edit update destroy ]

  

  def index
    @posts = Post.all
  end

  def show
    @comments = Comment.where(post_id: @post.id)
  end

  def new
    @post = Post.new
  end

  def create
    course_id = params[:course_id]

    @post = Post.new(user_id: @current_user.id, course_id: course_id,
                        title: post_params[:title], body: post_params[:body])

    if @post.save
      redirect_to controller: 'courses', action: 'show', id: course_id
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @post = Post.find_by(id: params[:id])
  end

  def update
    # @post = Post.find_by(id: params[:id])
    if @post.update(post_params)
      redirect_to controller: 'courses', action: 'show', id: @post.course_id
    else
      render :edit, status: :unprocessable_entity

    end
  end

  def destroy
      @post = Post.find(params[:id])
      Comment.where(post_id: @post.id).delete_all
      @post.destroy
    
      redirect_to course_path(@course), status: :see_other
    end

  private
  def post_params
    params.require(:post).permit(:course_id, :title, :body)
  end

  def set_post
    @user = @current_user
    @post = Post.find(params[:id])
    @course = Course.find(@post.course_id)
  end



end
