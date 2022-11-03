class AuthenticatedController < ApplicationController
    before_action :check_user, :set_user

    def check_user
        redirect_to root_path if (session[:current_user].nil? || User.find_by(id: session[:current_user]).nil?)
    end

    def set_user
        @current_user = User.find(session[:current_user])
    end
end
