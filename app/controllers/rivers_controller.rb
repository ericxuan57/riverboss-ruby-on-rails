class RiversController < ApplicationController

  before_action :authenticate_user, only: [:index]

  def home_page
    if user_signed_in?
      @rivers = get_weather_data current_user.rivers.includes(:state)
      unless @rivers.any?
        redirect_to new_users_river_path
      else
        render 'index'
      end
    else
      near_by
      render 'near_by'
    end
  end

  def index
    @rivers = get_weather_data current_user.rivers.includes(:state)
    redirect_to new_users_river_path unless @rivers.any?
  end

  def show
    @river = get_weather_data(Array(River.find params[:id])).first
    @river.increment
  end

  def autocomplete
    @rivers = River.where("name ILIKE ?", "#{params[:q]}%").sort_by_name.pluck(:id, :name)
    respond_to do |format|
      format.html
      format.json {
        render json: @rivers
      }
      format.mobile {
        render json: @rivers
      }
    end
  end

  def near_by
    lat = 41.5000526
    long = -83.7127145
    if cookies[:lat_lng].present?
      @lat_lng = cookies[:lat_lng].split("|")
      lat = @lat_lng[0]
      long = @lat_lng[1]
    else
      @location = location
      if @location.present? && @location.latitude.present? && @location.longitude.present?
        lat = @location.latitude
        long = @location.longitude
      end
    end
    @rivers = get_weather_data River.near([lat, long], River::NEARBYDISTANCE).limit(River::NEARBYRIVERCOUNT).includes(:state)
  end

  def search
    if params[:q].blank?
      @rivers = []
      return
    end
    @river = River.find_by_name(params[:q])
    if @river.present?
      redirect_to river_path @river
    else
      @rivers = River.where("name ILIKE ?", "%#{params[:q]}%").sort_by_short_name.page(params[:page])
    end
  end

  def popular
    @rivers = River.limit(River::POPULARRIVERCOUNT).order("views DESC")
  end

  def default_conditions
    @rivers = River.where("conditions IS NOT NULL").page(params[:page])
  end

end
