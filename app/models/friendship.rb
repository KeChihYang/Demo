class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: "User"

  # def self.mutual_friends
  #   User.find_by_sql ["SELECT users.* FROM users INNER JOIN friendships ON users.id = friendships.friend_id WHERE friendships.user_id = ? INTERSECT SELECT users.* FROM users INNER JOIN friendships ON users.id = friendships.user_id WHERE friendships.friend_id = ?",id,id]
  # end

end
