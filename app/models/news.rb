class News < ActiveRecord::Base
  mount_uploader :picture, PictureUploader

  scope :published, -> { where(is_published: true) }

  validates_presence_of :content, :picture
end
