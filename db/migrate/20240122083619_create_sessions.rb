class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.datetime :date
      t.decimal :durée, precision: 4, scale: 2, default: "0.0"

      t.timestamps
    end
  end
end
