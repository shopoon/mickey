class Couple < ActiveRecord::Base

  validates :mother_id, presence: true, uniqueness: true
  validates :father_id, presence: true, uniqueness: true
  validates :mated_at,  presence: true
  
  extend Enumerize
  enumerize :status, in: [:mating, :pregnant], default: :mating

  def father
    Mouse.find(father_id)
  end

  def mother
    Mouse.find(mother_id)
  end
end
