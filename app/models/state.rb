# == Schema Information
#
# Table name: states
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  code        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  radar_image :string(255)
#

class State < ActiveRecord::Base

  has_many :rivers, -> { order(name: :asc) }

  validates :name, :code, presence: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def self.for_menu
    order("name")
  end

end
