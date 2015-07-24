class HomeController < ApplicationController
  def index
    if !logged_in?
      redirect_to login_path
    else
      # p Time.now
      @mutual_friends = User.mutual_friends(current_user.id)
      gon.articles = Article.where(user_id: [@mutual_friends,current_user]).order(updated_at: :asc).as_json(include: {comments: { methods: [:user,:avatar_url]}}, methods: [:avatar_url, :owner, :owner_avatar_url])
      gon.current_user = current_user.as_json(:methods => [:avatar_url])
      gon.mutual_friends = @mutual_friends.as_json(:methods => :avatar_url)
      gon.unconfirmed_friends = User.unconfirmed_friends(current_user.id).as_json(:methods => :avatar_url)
      gon.not_friends = User.not_friends(current_user.id).as_json(:methods => :avatar_url)
      # gon.friendship = Friendship.all
    end
  end
  def searchnew
    @mutual_friends = User.mutual_friends(current_user.id)
    @articles = Article.where(user_id: [@mutual_friends,current_user]).order(updated_at: :asc)
    mutual_friends = @mutual_friends.as_json(:methods => :avatar_url)
    unconfirmed_friends = User.unconfirmed_friends(current_user.id).as_json(:methods => :avatar_url)
    not_friends = User.not_friends(current_user.id).as_json(:methods => :avatar_url)

    time_limit = 10.second
    articles = Article.where(updated_at: (Time.now-time_limit)...Time.now).where(user_id: [@mutual_friends,current_user]).order(:updated_at).as_json(include: {comments: { methods: [:user,:avatar_url]}}, methods: [:avatar_url, :owner, :owner_avatar_url])
    comments = Comment.where(updated_at: (Time.now-time_limit)...Time.now).where(article_id: @articles).order(:updated_at).as_json(methods: [:user,:avatar_url])
    deleteds = Deleted.where(updated_at: (Time.now-time_limit)...Time.now).order(:updated_at).as_json
    render json: {:articles => articles, :comments => comments, :deleteds => deleteds, :mutual_friends => mutual_friends, :unconfirmed_friends => unconfirmed_friends, :not_friends => not_friends}
  end

  def change_friendstate
    if params[:state]==="remove"
      @friendship1 = Friendship.find_by(:user_id => params[:user_id], :friend_id => params[:friend_id])
      @friendship1.destroy
      @friendship2 = Friendship.find_by(:user_id => params[:friend_id], :friend_id => params[:user_id])
      @friendship2.destroy
    end
    if params[:state]==="confirm"
      Friendship.create(:user_id => params[:user_id], :friend_id => params[:friend_id])
    end
    if params[:state]==="reject"
      @friendship = Friendship.find_by(:user_id => params[:friend_id],:friend_id => params[:user_id])
      @friendship.destroy
    end
    if params[:state]==="add"
      Friendship.create(:user_id => params[:user_id], :friend_id => params[:friend_id])
    end
    render json: {:error => "sadsa"}
  end

  def update
    @article = Article.find(params[:id])
    @article.update(body: params[:body])
    render json: {:error => @article.errors}
  end

  def finduser
    # users = User.find_by(name: params[:name]).as_json(methods: [:avatar_url])
    users = User.all
    render json: {:users => users}
  end

  def deleted
    @deleted = Deleted.new(deleted_params)
    @deleted.save()
    render json: {:error => @deleted.errors}
  end



  def create
    @article = current_user.articles.create(article_params)

    if @article.save
      redirect_to home_index_path
    else
      @photoerror = 'upload failed!'
      redirect_to home_index_path
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    render json: {:user => "u"}
  end



  private
    def article_params
      params.require(:article).permit(:avatar, :body)
    end
    def deleted_params
      params.require(:data).permit(:article_id, :comment_id)
    end
end
