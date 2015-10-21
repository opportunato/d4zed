class AddOrderToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :order_number, :integer, default: 0
  end
end
