class Cat < ActiveRecord::Base
  COLORS = %w{ red orange yellow green blue indigo violet }
  GENDERS = %w{ O F M }

  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: COLORS, message: "%{value} is not a valid color" }
  validates :sex, inclusion: { in: GENDERS, message: "%{value} is not a valid option" }

  def self.get_genders
    GENDERS
  end

  def self.get_colors
    COLORS
  end

  def age
    Integer(Integer(Date.today - birth_date) / 365.25)
  end
end
