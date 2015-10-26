class RenameBrandToName < ActiveRecord::Migration
  def change
    remove_column :brands, :name
    rename_column :brands, :brand, :name
  end
end
