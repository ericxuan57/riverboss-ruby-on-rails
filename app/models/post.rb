# == Schema Information
#
# Table name: posts
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

class Post < ActiveRecord::Base

  validates :title, :content, :status, presence: true

  after_create :clear_cache

  # Number of Rivers per page
  paginates_per 20

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def self.recent
    Rails.cache.fetch 'posts/recent' do
      where(status: "Published").limit(4).order("created_at DESC")
    end
  end

  private

  def clear_cache
    Rails.cache.delete 'posts/recent'
  end

end
