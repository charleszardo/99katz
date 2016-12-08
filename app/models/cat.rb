class Cat < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  COLORS = %w{ red orange yellow green blue indigo violet }
  GENDERS = %w{ O F M }

  validates :birth_date, :color, :name, :sex, :owner, presence: true
  validates :color, inclusion: COLORS
  validates :sex, inclusion: GENDERS

  has_many :cat_rental_requests, :dependent => :destroy
  belongs_to :owner, foreign_key: "user_id", class_name: "User"

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
