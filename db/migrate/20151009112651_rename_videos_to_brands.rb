class RenameVideosToBrands < ActiveRecord::Migration
  def change
    rename_table :videos, :brands
  end
end
