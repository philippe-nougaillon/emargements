class AddGoogleFieldsToUser < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :uid
      t.string :provider
    end
  end
end
