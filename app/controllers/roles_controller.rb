class RolesController < AuthenticatedController

  def index
  end

  def new
    @role = Role.new
  end

  def create
    @user_email = role_params[:user_email].downcase
    @user = User.where(email: @user_email).first

    if @user
      @course = Course.find(params[:id])
      @role = Role.new(user: @user, course: @course, role: 1)

      if @role.save
        redirect_to course_url(@course)
      else
        render :new, status: :unprocessable_entity
      end
    else
      # needs to be fixed since @role is Nil
      @role.errors.add(:user_email, "User #{@user_email} doesn't exist!")
    end

  end

  def remove_student
    @course = Course.find(params[:id])
    @user = User.find(params[:user_id])
    @role = Role.where(user:@user, course: @course).first
    @role.destroy

    respond_to do |format|
      format.html { redirect_to course_url(@course), notice: "#{@user} was successfully removed from #{@course}." }
      format.json { head :no_content }
    end
  end

  private


  def role_params
    params.require(:role).permit(:user_email)
  end
end
