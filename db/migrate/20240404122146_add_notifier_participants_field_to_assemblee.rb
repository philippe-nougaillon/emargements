class AddNotifierParticipantsFieldToAssemblee < ActiveRecord::Migration[7.1]
  def change
    add_column :assemblees, :notifier_participants, :boolean, default: false
  end
end
