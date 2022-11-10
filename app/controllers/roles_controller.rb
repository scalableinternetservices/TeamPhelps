class RolesController < ApplicationController

  def index
  end

  def new
    logger.info "Instantiating Role"
    @role = Role.new
  end

  def create
    @user_email = role_params[:user_email].downcase!
    @user = User.where(email: @user_email)
    logger.info "role #{@role}"
    if not @user.empty?
      @course = Course.find(params[:id])
      logger.info "User_id #{@user}"
      logger.info "Course_id #{@course}"
      # @role = Role.new(user: @user, course: @course, role: 1)
      @role.user = @user
      @role.course = @course

      if @role.save
        redirect_to course_url(@course)
      else
        render :new, status: :unprocessable_entity
      end
    else
      @role.errors.add(:user_email, "User #{@user_email} doesn't exist!")
    end

  end


  private


  def role_params
    params.require(:role).permit(:user_email)
  end
end
