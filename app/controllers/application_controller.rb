class ApplicationController < ActionController::Base
skip_before_action :verify_authenticity_token

def render_not_found
    render :file => "#{Rails.root}/public/404.html",  :status => 404
    end
end
