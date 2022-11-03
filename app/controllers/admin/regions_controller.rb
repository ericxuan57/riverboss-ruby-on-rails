class Admin::RegionsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @regions = Region.all.includes(:rivers)
  end

end
