class Mouse < ActiveRecord::Base
  belongs_to :family

  extend Enumerize
  enumerize :sex, in: [:male, :female], default: :male 
  enumerize :status, in: [:available, :reserved, :used], default: :available

  scope :available, -> { where(status: :available) }
  scope :by_family_id, -> (family_id) { where(family_id: family_id).default_order }
  scope :default_order, -> { order('id ASC, sequence_id ASC') }
  scope :waiting, -> { where(status: :waiting).default_order }
  scope :male, -> { where(sex: :male) }
  scope :female, -> { where(sex: :female) }

  def display_name
    self.family.display_name + "(#{sequence_id})"
  end

  def update_status(status)
    self.update_attributes(status: status)
  end
end
