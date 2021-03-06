class CatRentalRequest < ActiveRecord::Base
  STATUSES = %w{ PENDING APPROVED DENIED }

  after_initialize :assign_pending_status

  validates :cat, :start_date, :end_date, :status, :requester, presence: true
  validates :status, inclusion: STATUSES
  validate :approved_requests_cannot_overlap
  validate :start_date_must_occur_before_or_on_end_date
  validate :start_date_cannot_be_in_past
  validate :owner_cannot_request_rental_of_own_cat

  belongs_to :cat
  belongs_to :requester, class_name: "User"

  def overlapping_requests
    CatRentalRequest
      .where.not(id: self.id)
      .where(cat_id: self.cat_id)
      .where('start_date >= ? AND end_date <= ?', self.start_date, self.end_date)
  end

  def approve!
    raise 'not pending' unless self.status == "PENDING"
    transaction do
      self.status = "APPROVED"
      self.save!

      overlapping_pending_requests.update_all(status: 'DENIED')
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def pending?
    self.status == "PENDING"
  end

  # private
  def assign_pending_status
    self.status ||= "PENDING"
  end

  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  def approved_requests_cannot_overlap
    if status == 'APPROVED' && !overlapping_approved_requests.empty?
      errors[:approval] << 'Cat rental already approved for this time'
    end
  end

  def start_date_must_occur_before_or_on_end_date
    if start_date > end_date
      errors[:request] << 'end date must occur on or after start_date'
    end
  end

  def start_date_cannot_be_in_past
    if start_date < Date.today
      errors[:request] << 'start date cannot be in past'
    end
  end

  def owner_cannot_request_rental_of_own_cat
    if User.find_by_id(self.requester_id).owns_cat?(self.cat_id)
      errors[:errors] = "Owner cannot request to rent own cat"
    end
  end
end
