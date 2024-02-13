class AddNomAndAdresseToAssemblee < ActiveRecord::Migration[7.1]
  def change
    add_column :assemblees, :nom, :string
    add_column :assemblees, :adresse, :string
  end
end
