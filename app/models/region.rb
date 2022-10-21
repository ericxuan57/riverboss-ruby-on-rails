# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  views      :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class Region < ActiveRecord::Base

  has_and_belongs_to_many :rivers, order: "name ASC"

  validates :name, presence: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def self.for_menu
    order("name")
  end

  def increment(by = 1)
    self.views ||= 0
    self.views += by
    self.save
    Rails.cache.delete 'regions/popular'
  end

  def self.popular
    Rails.cache.fetch 'regions/popular' do
      order("views DESC").limit(5)
    end
  end

end
