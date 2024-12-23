class CreateVaccinations < ActiveRecord::Migration[7.1]
  def change
    create_table :vaccinations do |t|
      t.references :pet, null: false, foreign_key: true
      t.string :vaccine_type
      t.date :application_date
      t.date :next_dose_date
      t.text :notes

      t.timestamps
    end
  end
end
