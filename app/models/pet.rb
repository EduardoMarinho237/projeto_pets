class Pet < ApplicationRecord
  belongs_to :user

  has_many :consultations, dependent: :destroy
  has_many :vaccinations, dependent: :destroy

  validates :name, presence: { message: "Name cannot be blank." }
  validates :species, presence: { message: "Species cannot be blank." }

  def dynamic_age
    return 'RN' if birth_date.blank?
  
    current_time = Time.zone.now
    age_in_months = ((current_time - birth_date.to_time) / 1.month).floor
  
    if age_in_months < 1
      'RN' # Recém-nascido
    elsif age_in_months < 12
      "#{age_in_months} meses"
    else
      years = (age_in_months / 12).floor
      months = age_in_months % 12
      months.positive? ? "#{years} anos e #{months} meses" : "#{years} anos"
    end
  end

  # Verifica se o pet pertence ao usuário especificado
  def owned_by?(user)
    self.user_id == user.id
  end
end
