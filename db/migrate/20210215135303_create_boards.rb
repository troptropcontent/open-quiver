class CreateBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.string :brand
      t.string :name
      t.float :length
      t.float :thickness
      t.float :width
      t.float :volume
      t.float :price
      t.float :longitude
      t.float :latitude
      t.string :status

      t.timestamps
    end
  end
end
