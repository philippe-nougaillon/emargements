class AddFinToAssemblee < ActiveRecord::Migration[7.1]
  def change
    add_column :assemblees, :fin, :datetime
  end
end
