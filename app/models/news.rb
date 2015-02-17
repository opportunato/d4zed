class News < ActiveRecord::Base
  mount_uploader :picture, PictureUploader

  scope :published, -> { where(is_published: true).order(:created_at) }

  validates_presence_of :content, :picture
end
