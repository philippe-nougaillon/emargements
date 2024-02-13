class AddUserReferenceToPresence < ActiveRecord::Migration[7.1]
  def change
    add_reference :presences, :user, null: false, foreign_key: true
  end
end
