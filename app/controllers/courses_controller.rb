class CoursesController < AuthenticatedController
    before_action :check_id
    before_action :set_course, only: %i[ show edit update destroy join leave]
  
    # GET /posts or /posts.json
    def index
      @courses = Course.order(:name).page params[:page]
      #Temporary variable for the navbar, until we find a better solution
      @user = @current_user
    end
  
    def show
      @roles = Role.where(course_id: @course.id).order(:user_id).page params[:mem_pagina]
      #Temporary variable for the navbar, until we find a better solution
      @user = @current_user

      @role = Role.where(user_id: @user, course_id:@course.id).first
      @posts = Post.where(course_id: @course.id).order(:created_at).page params[:posts_pagina]

      user_ids = []
      @posts.each do |post|
        user_ids << post.user_id
      end
      posts_users = User.where(id: user_ids)
      @posts_users_hash = Hash[posts_users.collect { |v| [v.id, v]}]


    end
  
    def new
      @course = Course.new
      @user = @current_user
    end
  
    def edit
      #Temporary variable for the navbar, until we find a better solution
      @user = @current_user

    end

    def leave
      current_role = @course.roles.find_by(user_id: @current_user.id)
      if current_role.role == 1 or current_role.role == 2
        @course.roles.find_by(user_id: @current_user.id).destroy
      end
        redirect_to @current_user
    end
  
    def create
      @user = @current_user
      @course = Course.new(course_params)
      @course.roles.build(user: @current_user, course: @course, role:0)
      # @course.users << User.find(@current_user.id)

  
      respond_to do |format|
        if @course.save
          format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
          format.json { render :show, status: :created, location: @course }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    end

    def join
      @course.roles.create(user: @current_user, course: @course, role: 1)
      redirect_to course_url(@course)
    end
  
    def update
      respond_to do |format|
        if @course.update(course_params)
          format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
          format.json { render :show, status: :ok, location: @course }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      roles = Role.where(course_id: @course.id)
      roles.each do |role|
        role.destroy
      end
      
      posts = Post.where(course_id: @course.id)
      posts.each do |post|
        post.destroy
      end
      
      @course.destroy
      redirect_to courses_path, notice: "Course was successfully destroyed", status: :see_other

    end
  
    private
  
      def check_id
        return render_not_found unless (!params[:id] or Course.find_by(id: params[:id]))
      end
    
    # Use callbacks to share common setup or constraints between actions.
      def set_course
        @course = Course.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def course_params
        params.require(:course).permit(:name)
      end
  end
  