class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :article
  validates :body, presence: true
  validates :article_id, presence: true
  validates :user_id, presence: true

  def avatar_url
    User.find(user_id).profile.avatar.url(:thumb)
  end
  def user
    User.find(user_id)
  end
end
