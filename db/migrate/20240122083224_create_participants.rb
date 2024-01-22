class CreateParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :participants do |t|
      t.string :nom, null: false
      t.string :prénom, null: false

      t.timestamps
    end
  end
end
