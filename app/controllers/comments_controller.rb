class CommentsController < AuthenticatedController
    before_action :set_comment, only: %i[ show edit update destroy ]
  
    
  
    def show
        
    end
  
    def new
      @comment = Comment.new
    end
  
    def create
      course_id = params[:course_id]
      post_id = params[:post_id]
  
      @comment = Comment.new(user_id: @current_user.id, post_id: post_id,
                         body: comment_params[:body])
  
      if @comment.save
        redirect_to controller: 'posts', action: 'show', id: post_id
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @comment.update(comment_params)
        redirect_to controller: 'posts', action: 'show', id: @comment.post_id
      else
        render :edit, status: :unprocessable_entity
  
      end
    end

    def destroy
          @comment = Comment.find(params[:id])
          post = @comment.post_id
          @comment.destroy
        
          redirect_to course_post_path(id: post), status: :see_other
        end
  
    private
    def comment_params
      params.require(:comment).permit(:body)
    end
  
    def set_comment
      @comment = Comment.find(params[:id])
      @post = Post.find(@comment.post_id)
    end
  
  
    
    #
    # def destroy
    #   # logger.info "Processing the request... "
    #   @post = Post.find(params[:id])
    #   @post.destroy
    #
    #   redirect_to root_path, status: :see_other
    # end
    #
  
  
  end
  