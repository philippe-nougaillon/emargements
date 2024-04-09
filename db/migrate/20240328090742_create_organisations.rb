class CreateOrganisations < ActiveRecord::Migration[7.1]
  def change
    create_table :organisations do |t|
      t.string :nom
      t.string :adresse

      t.timestamps
    end
  end
end
