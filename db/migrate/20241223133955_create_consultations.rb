class CreateConsultations < ActiveRecord::Migration[7.1]
  def change
    create_table :consultations do |t|
      t.references :pet, null: false, foreign_key: true
      t.date :date
      t.string :type
      t.string :veterinarian
      t.text :notes

      t.timestamps
    end
  end
end
