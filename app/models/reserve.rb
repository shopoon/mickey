class Reserve < ActiveRecord::Base
  belongs_to :user
  belongs_to :family

  serialize :mouse_ids

  scope :by_user_id, -> (user_id) { where(user_id: user_id) }
  scope :default_order, -> { order('reserved_at ASC, use_at ASC') }
end
