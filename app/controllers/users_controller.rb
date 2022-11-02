class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
      end

      def login
        @user = User.find_by(name: params[:name])
        if @user
            session[:current_user] = @user.id
            redirect_to controller: 'users', action: 'show', id: @user.id 
        else
            message = "Something went wrong! Username or email incorrect!"
            redirect_to login_path, alert: message
        end
      end

      def new
        @users = User.all
        @user = User.new
      end

      def create
        @user = User.new(user_params)
        @users = User.all
    
        if @user.save
          session[:current_user] = @user.id
          redirect_to controller: 'users', action: 'show', id: @user.id
        else
          render :new, status: :unprocessable_entity
        end
      end
      
      def edit
        @user = User.find(params[:id])
      end
    
      def update
        @users = User.all
        @user = User.find(params[:id])
    
        if @user.update(user_params)
          session[:current_user] = @user.id
          redirect_to controller: 'users', action: 'show', id: @user.id
        else
          render :new, status: :unprocessable_entity
        end
      end
    
      def destroy
        User.destroy(params[:id])
        redirect_to root_path, status: :see_other
      end
    
      private
      def user_params
        params.require(:user).permit(:name, :email)
      end

end
