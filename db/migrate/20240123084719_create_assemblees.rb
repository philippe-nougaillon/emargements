class CreateAssemblees < ActiveRecord::Migration[7.1]
  def change
    create_table :assemblees do |t|
      t.datetime :début
      t.decimal :durée, precision: 4, scale: 2, default: "0.0"

      t.timestamps
    end
  end
end
