class CreatePresences < ActiveRecord::Migration[7.1]
  def change
    create_table :presences do |t|
      t.string :nom
      t.string :prénom
      t.datetime :heure
      t.string :signature

      t.timestamps
    end
  end
end
