class RemovePresenceReferences < ActiveRecord::Migration[7.1]
  def change
    remove_reference :presences, :participant, index: true, foreign_key: true
  end
end
