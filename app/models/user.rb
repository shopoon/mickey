class User < ActiveRecord::Base
  has_many :reserves

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  extend Enumerize
  enumerize :role, in: [:super_admin, :admin, :viewer], default: :viewer

  def email_required?
    false
  end
end
