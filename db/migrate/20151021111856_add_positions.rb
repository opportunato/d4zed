class AddPositions < ActiveRecord::Migration
  def change
    Position.create(name: "Creative director")
    Position.create(name: "Programmer")
    Position.create(name: "Designer")
  end
end
