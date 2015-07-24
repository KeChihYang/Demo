class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

  has_attached_file :avatar, :styles => {:thumb => "100x100>"}, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates :avatar, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :avatar
  validates_with AttachmentSizeValidator, :attributes => :avatar, :less_than => 1.megabytes

  def avatar_url
    avatar.url(:thumb)
  end
  def owner
    User.find(user_id)
  end
  def owner_avatar_url
    User.find(user_id).profile.avatar.url(:thumb)
  end
end
