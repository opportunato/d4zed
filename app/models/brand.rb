class Brand < ActiveRecord::Base
  include Taggable

  has_many :media, -> { order(order_number: :desc) }, dependent: :destroy
  accepts_nested_attributes_for :media, :allow_destroy => true

  before_save :set_order_number

  enum size: [ :small, :big ]

  mount_uploader :thumbnail, ThumbnailUploader

  scope :published, -> { where(is_published: true).order('order_number DESC, created_at DESC') }

  validates_presence_of :name, :size

  def interactive?
    media.first.link.present?
  end

  def set_order_number
    if self.order_number.blank?
      self.order_number = Brand.all.order('order_number DESC').first.order_number
    end
  end
end
