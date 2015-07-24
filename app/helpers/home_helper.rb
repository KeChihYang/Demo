module HomeHelper
  def article_owner(article)
    @user = User.find(article.user_id)
  end
  def article_comments(article)
    @comments = article.comments.all
  end
  def comments_owner(comment)
    @comment_user = User.find(comment.user_id)
  end
end
