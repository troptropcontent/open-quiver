class AddAddressToBoards < ActiveRecord::Migration[6.0]
  def change
    add_column :boards, :street, :string
    add_column :boards, :city, :string
    add_column :boards, :zipcode, :integer
    add_column :boards, :country, :string
  end
end
