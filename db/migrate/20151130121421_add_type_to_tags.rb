class AddTypeToTags < ActiveRecord::Migration
  def change
    add_column :tags, :kind, :integer, default: 0
  end
end
