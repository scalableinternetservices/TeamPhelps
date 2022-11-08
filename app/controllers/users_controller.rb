class UsersController < ApplicationController

      def index 
        if session[:current_user] && User.find_by(id: session[:current_user]).present?
            redirect_to controller: 'users', action: 'show', id: session[:current_user]
        else
          session[:current_user] = nil
        end
      end
      
      def show
        @user = User.find(params[:id])
        @courses = @user.courses
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
        @user = User.new
      end

      def create
        @user = User.new(user_params)
    
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

      def logout
        session[:current_user] = nil
        redirect_to root_path
      end
    
      private
      def user_params
        params.require(:user).permit(:name, :email)
      end

end
