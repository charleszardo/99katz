class CatRentalRequest < ActiveRecord::Base
  STATUSES = %w{ PENDING APPROVED DENIED }

  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: STATUSES
  validate :approved_requests_cannot_overlap

  belongs_to :cat

  def overlapping_requests
    CatRentalRequest
      .where.not(id: self.id)
      .where(cat_id: self.cat_id)
      .where('start_date < ? OR end_date > ?', self.end_date, self.start_date)
  end

  private

  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  def approved_requests_cannot_overlap
    if self.status == 'APPROVED' && !overlapping_approved_requests.empty?
      errors[:approval] << 'Cat rental already approved for this time'
    end
  end
end
