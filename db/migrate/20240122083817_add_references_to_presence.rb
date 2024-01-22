class AddReferencesToPresence < ActiveRecord::Migration[7.1]
  def change
    remove_column :presences, :nom
    remove_column :presences, :prénom
    add_reference :presences, :participant, null: false, foreign_key: true
    add_reference :presences, :session, null: false, foreign_key: true
  end
end
