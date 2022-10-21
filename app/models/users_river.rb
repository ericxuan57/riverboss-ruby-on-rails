# == Schema Information
#
# Table name: users_rivers
#
#  id         :integer          not null, primary key
#  river_id   :integer
#  user_id    :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  conditions :hstore
#

class UsersRiver < ActiveRecord::Base

  belongs_to :user
  belongs_to :river

  validates :user_id, :river_id, presence: true
  validates :river_id, uniqueness: { scope: :user_id, message: "This river is already present in your My Rivers." }

  acts_as_list scope: :user

  after_create :set_position

  private

  def set_position
    self.move_to_top
  end

end
