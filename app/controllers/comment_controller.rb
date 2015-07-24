class CommentController < ApplicationController
  def create
    # @article = Article.find(params[:article_id])
    # @user = current_user
    @comment = Comment.new(comment_params)
    if @comment.save
      render :json => {:comment => @comment.as_json(:methods => [:avatar_url, :user])}
    else
      render :json => {:error => @comment.errors.as_json}
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(body: params[:body])
    p @comment.errors
    render json: {:error => @comment.errors}
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render :json => {:error => "sada"}
  end
  private
    def comment_params
      params.require(:comment).permit(:body, :user_id, :article_id)
    end
    # def aid_params
    #   params.require(:comment).permit(:article_id)
    # end
end
