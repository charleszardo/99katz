class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: COLORS, message: "%{value} is not a valid color"}

  COLORS = %w{ red orange yellow green blue indigo violet }
end
