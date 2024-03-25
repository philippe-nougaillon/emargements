class AddSlugToAssemblees < ActiveRecord::Migration[7.1]
  def change
    add_column :assemblees, :slug, :string
    add_index :assemblees, :slug, unique: true

    Assemblee.find_each(&:save)
  end
end
