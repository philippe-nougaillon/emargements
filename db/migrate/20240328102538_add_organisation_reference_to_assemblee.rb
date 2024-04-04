class AddOrganisationReferenceToAssemblee < ActiveRecord::Migration[7.1]
  def change
    add_reference :assemblees, :organisation, null: false, foreign_key: true
  end
end
