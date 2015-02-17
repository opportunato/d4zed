class AddSizeToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :size, :integer, default: 0
  end
end
