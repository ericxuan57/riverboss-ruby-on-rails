# == Schema Information
#
# Table name: pages
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  content          :text
#  status           :string(255)      default("published")
#  meta_keywords    :string(255)
#  meta_description :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  slug             :string(255)
#

class Page < ActiveRecord::Base

  validates :title, :content, :status, presence: true

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

end
