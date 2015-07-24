class Profile < ActiveRecord::Base
  belongs_to :user

  has_attached_file :avatar, :styles => {:thumb => "25x25>"}, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates :avatar, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :avatar
  validates_with AttachmentSizeValidator, :attributes => :avatar, :less_than => 1.megabytes

  def avatar_url
    avatar.url(:thumb)
  end

end
