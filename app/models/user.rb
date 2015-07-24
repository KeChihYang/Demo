class User < ActiveRecord::Base
  # def self.authenticate(password)
  #   if user.find_by_password(password)
  #     return true
  #   else
  #     return false
  #   end
  # end

  # has_many :photos, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user



  has_secure_password
  validates :name, presence: true
  validates :email, :email_format => {:message => 'is not looking good'},
                    uniqueness: true

  def avatar_url
    profile.avatar.url(:thumb)
  end
  def self.not_friends(id)
    User.find_by_sql ["SELECT users.* FROM users WHERE (id != #{id}) EXCEPT SELECT users.* FROM users INNER JOIN friendships ON users.id = friendships.friend_id WHERE friendships.user_id = #{id} EXCEPT SELECT users.* FROM users INNER JOIN friendships ON users.id = friendships.user_id WHERE friendships.friend_id = #{id}"]
  end
  def self.mutual_friends(id)
    User.find_by_sql ["SELECT users.* FROM users INNER JOIN friendships ON users.id = friendships.friend_id WHERE friendships.user_id = #{id} INTERSECT SELECT users.* FROM users INNER JOIN friendships ON users.id = friendships.user_id WHERE friendships.friend_id = #{id}"]
  end
  def self.unconfirmed_friends(id)
    User.find_by_sql ["SELECT users.* FROM users INNER JOIN friendships ON users.id = friendships.user_id WHERE friendships.friend_id = #{id} EXCEPT SELECT users.* FROM users INNER JOIN friendships ON users.id = friendships.friend_id WHERE friendships.user_id = #{id}"]
  end

end
