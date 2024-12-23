class RenameTypeToConsultationTypeInConsultations < ActiveRecord::Migration[7.1]
  def change
    rename_column :consultations, :type, :consultation_type
  end
end
