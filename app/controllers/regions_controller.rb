class RegionsController < ApplicationController

  def index
    @regions = Region.all.order(name: :asc)
  end

  def show
    region = Array(Region.where("slug = '#{params[:id]}'"))
    region_id = 0
    region.each do |r|
      region_id = r.id
    end
    @region = Region.find(region_id)
    @rivers = get_weather_data(@region.rivers.includes(:state))
    @region.increment
  end

end
