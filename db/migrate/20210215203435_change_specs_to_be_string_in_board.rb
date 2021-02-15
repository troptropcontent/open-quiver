class ChangeSpecsToBeStringInBoard < ActiveRecord::Migration[6.0]
  def change
    change_column :boards, :length, :string
    change_column :boards, :thickness, :string
    change_column :boards, :width, :string
    change_column :boards, :volume, :string
  end
end
