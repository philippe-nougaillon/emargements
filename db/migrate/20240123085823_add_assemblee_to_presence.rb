class AddAssembleeToPresence < ActiveRecord::Migration[7.1]
  def change
    add_reference :presences, :assemblee, null: false, foreign_key: true
  end
end
