class PostsController < AuthenticatedController
  before_action :check_id
  before_action :set_post, only: %i[ show edit update destroy ]



  def index
    @posts = Post.order(:title).page params[:page]
  end

  def show
    @comments = Comment.where(post_id: @post.id).order(:created_at).page params[:comments_pagina]
    @post_user = User.find(@post.user_id)
  end

  def new
    @post = Post.new
    @user = @current_user
    @course = Course.find(params[:course_id])

  end

  def create
    @user = @current_user
    course_id = params[:course_id]
    @course = Course.find(course_id)
    @post = Post.new(user_id: @current_user.id, course_id: course_id,
                     title: post_params[:title], body: post_params[:body])


    if @post.save
      redirect_to controller: 'courses', action: 'show', id: course_id
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless helpers.is_instructor?(@role.role) or (@post.user_id == @current_user.id)
      render_not_found
    end
  end

  def update

    if helpers.is_instructor?(@role.role) or (@post.user_id == @current_user.id)
      if @post.update(post_params)
        redirect_to controller: 'courses', action: 'show', id: @post.course_id
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to course_post_path @post
    end

  end

  def destroy
    if helpers.is_instructor?(@role.role) or (@post.user_id == @current_user.id)
      @post = Post.find(params[:id])
      Comment.where(post_id: @post.id).delete_all
      @post.destroy
      redirect_to course_path(@course), status: :see_other
    end
  end

  private
  def post_params
    params.require(:post).permit(:course_id, :title, :body)
  end

  def set_post
    @user = @current_user
    @post = Post.find(params[:id])
    @course = Course.find(@post.course_id)
    @role = Role.where(course_id: @course, user_id: @current_user).first
  end

  def check_id
    render_not_found unless (!params[:id] or Post.find_by(id: params[:id]))
  end



end
