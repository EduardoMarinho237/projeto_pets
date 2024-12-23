class Vaccination < ApplicationRecord
  belongs_to :pet

  validates :vaccine_type, :application_date, presence: true

  validate :application_date_cannot_be_in_the_past
  validate :next_dose_date_cannot_be_in_the_past
  validate :doses_cannot_be_in_the_same_day

  private

  def application_date_cannot_be_in_the_past
    if application_date.present? && application_date < Date.today
      errors.add(:application_date, "can't be in the past")
    end
  end

  def next_dose_date_cannot_be_in_the_past
    if next_dose_date.present? && next_dose_date < Date.today
      errors.add(:next_dose_date, "can't be in the past")
    end
  end

  def doses_cannot_be_in_the_same_day
    if next_dose_date == application_date
      errors.add(:next_dose_date, "cannot be on the same day as the first")
    end
  end
end
