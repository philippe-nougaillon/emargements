class AddSlugToUsersAndOrganisation < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true

    add_column :organisations, :slug, :string
    add_index :organisations, :slug, unique: true

    User.find_each(&:save)
    Organisation.find_each(&:save)
  end
end
