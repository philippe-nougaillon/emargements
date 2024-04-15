class AddPremiumFieldsToOrganisation < ActiveRecord::Migration[7.1]
  def change
    add_column :organisations, :premium, :boolean, default: false
    add_column :organisations, :expiration_premium, :datetime

    Organisation.update_all(premium: false)
  end
end
