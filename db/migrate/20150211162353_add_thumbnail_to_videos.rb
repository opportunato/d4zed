class AddThumbnailToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :thumbnail, :string

    add_column :videos, :created_at, :datetime
    add_column :videos, :updated_at, :datetime
  end
end
