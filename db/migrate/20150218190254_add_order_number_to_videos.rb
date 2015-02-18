class AddOrderNumberToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :order_number, :integer, default: 0
  end
end
