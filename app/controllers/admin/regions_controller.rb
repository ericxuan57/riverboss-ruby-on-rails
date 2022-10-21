class Admin::RegionsController < ApplicationController

  before_filter :authenticate_admin!

  def index
    @regions = Region.all.includes(:rivers)
  end

end
