class Consultation < ApplicationRecord
  belongs_to :pet

  validates :date, :consultation_type, presence: true

  validate :date_cannot_be_in_the_past

  private

  def date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end


end
