class RegionsController < ApplicationController

  def index
    @regions = Region.all.order(name: :asc)
  end

  def show
    @region = Region.find(params[:id])
    @rivers = get_weather_data(@region.rivers.includes(:state))
    @region.increment
  end

end