class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :species
      t.string :breed
      t.date :birth_date
      t.decimal :weight
      t.string :photo

      t.timestamps
    end
  end
end
