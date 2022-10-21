# == Schema Information
#
# Table name: rivers
#
#  id         :integer          not null, primary key
#  site_no    :string(255)
#  name       :string(255)
#  name_short :string(255)
#  latitude   :float
#  longitude  :float
#  state_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  views      :integer          default(0)
#  slug       :string(255)
#  conditions :hstore
#  city       :string(255)
#  region_id  :integer
#

class River < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :state
  has_and_belongs_to_many :regions
  has_many :users_rivers, dependent: :destroy
  has_many :users, through: :users_rivers

  reverse_geocoded_by :latitude, :longitude

  validates :name, :name_short, :state_id, presence: true
  validates :site_no, :latitude, :longitude, numericality: true, presence: true

  before_save :validate_conditions

  attr_accessor :discharge, :gauge_height, :water_temp, :turbidity, :usgs_updated_at, :weather

  scope :sort_by_short_name, -> { order(name_short: :asc) }
  scope :sort_by_name, -> { order(name: :asc) }

  NEARBYDISTANCE    = 50
  MYRIVERCOUNT      = 25
  POPULARRIVERCOUNT = 50
  NEARBYRIVERCOUNT  = 10

  # Number of Rivers per page
  paginates_per 50

  def increment(by = 1)
    self.views ||= 0
    self.views += by
    self.save
    Rails.cache.delete 'rivers/popular'
  end

  def self.popular
    Rails.cache.fetch 'rivers/popular' do
      order("views DESC").limit(5).includes(:state)
    end
  end

  private

  def validate_conditions
    return true if self.conditions.blank? || self.conditions["high"].blank? && self.conditions["low"].blank?

    if self.conditions["high"].blank? || self.conditions["low"].blank?
      self.errors.add(:conditions, "All two values must be present")
      return false
    end

    self.conditions["high"] = self.conditions["high"].to_i
    self.conditions["low"] = self.conditions["low"].to_i

    if self.conditions["high"] <= self.conditions["low"]
      self.errors.add(:conditions, "'High' should be greater than 'Low'")
      return false
    end
  end

end
