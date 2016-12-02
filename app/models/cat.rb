class Cat < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  COLORS = %w{ red orange yellow green blue indigo violet }
  GENDERS = %w{ O F M }

  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: COLORS
  validates :sex, inclusion: GENDERS

  def self.get_genders
    GENDERS
  end

  def self.get_colors
    COLORS
  end

  def age
    time_ago_in_words(birth_date)
  end
end
