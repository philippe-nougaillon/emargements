class AddAutomatiqueFieldToAssemblee < ActiveRecord::Migration[7.1]
  def change
    add_column :assemblees, :automatique, :boolean, default: :false
  end
end
