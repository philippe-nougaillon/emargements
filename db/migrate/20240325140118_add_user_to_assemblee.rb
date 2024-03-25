class AddUserToAssemblee < ActiveRecord::Migration[7.1]
  def change
    Assemblee.destroy_all

    add_reference :assemblees, :user, null: false, foreign_key: true
  end
end
