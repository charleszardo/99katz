class Cat < ActiveRecord::Base
  COLORS = %w{ red orange yellow green blue indigo violet }
  GENDERS = %{ O F M }

  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: COLORS, message: "%{value} is not a valid color" }
  validates :gender, inclusion: { in: GENDERS, message: "%{value} is not a valid option" }

  def age
    Integer(Integer(Date.today - birth_date) / 365.25)
  end
end
