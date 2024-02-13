class RemoveParticipant < ActiveRecord::Migration[7.1]
  def change
    drop_table :participants
  end
end
