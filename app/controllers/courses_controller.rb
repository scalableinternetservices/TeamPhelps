class CoursesController < AuthenticatedController
    before_action :check_id
    before_action :set_course, only: %i[ show edit update destroy ]
  
    # GET /posts or /posts.json
    def index
      @courses = Course.all
      #Temporary variable for the navbar, until we find a better solution
      @user = @current_user
    end
  
    def show
      @roles = Role.where(course_id: @course.id)
      #Temporary variable for the navbar, until we find a better solution
      @user = @current_user
    end
  
    def new
      @course = Course.new
    end
  
    def edit
      #Temporary variable for the navbar, until we find a better solution
      @user = @current_user

    end
  
    def create
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
  
      @course.destroy
  
      respond_to do |format|
        format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
        format.json { head :no_content }
      end
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
  