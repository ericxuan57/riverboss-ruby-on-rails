class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate

  # Mobile Detection
  has_mobile_fu

  before_action :force_views

  before_action :add_www_subdomain

  def location
    if params[:location].blank?
      if Rails.env.test? || Rails.env.development?
        @location ||= Geocoder.search("50.78.167.161").first
      else
        @location ||= request.location
      end
    else
      params[:location].each {|l| l = l.to_i } if params[:location].is_a? Array
      @location ||= Geocoder.search(params[:location]).first
      @location
    end
  end

  def after_sign_in_path_for(resource)
    params[:redirect_to] || session["user_return_to"] || rivers_path
  end

  protected
  def force_views
    unless request.format == "json"
      if cookies[:view].present?
        if cookies[:view] == "mobile"
          request.format = :mobile
        else
          request.format = :html
        end
      else
        request.format = :mobile if is_tablet_device?
      end

      # Force html format for post devise methods
      request.format = :html if devise_controller? && ["POST", "DELETE", "UPDATE"].include?(request.method) && ['create', 'update', 'destroy'].include?(action_name)
    end
  end

  def authenticate_user
    unless user_signed_in?
      redirect_to "/login?redirect_to=#{request.path}"
    end
  end

  def authenticate_admin!
    redirect_to "/login?redirect_to=#{request.path}" and return unless user_signed_in?
    redirect_to root_path, notice: "You don't have access to this page" and return unless current_user.admin?
  end

  def configure_permitted_parameters
    # add strong params for devise
    # devise_parameter_sanitizer.for(:sign_up) << :username
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "riverb" && password == "boss"
    end
  end

  def get_weather_data(rivers)
    redis = Redis.new(url: "redis://:RUnUMMXb3t2c4CDQDgHbNwRJvaa2vgzVzKHM@a3c15323be0b4d9ea57a5d4bb3fc59e3.publb.rackspaceclouddb.com:6379/")
    # redis = Redis.new(url: "redis://redistogo:b7ceef409eb19d131605aa3645797e1a@hoki.redistogo.com:9912/")
    # redis = Redis.new(host: "127.0.0.1", port: 6379, db: 5)
    rivers.each do |r|
      d = redis.hmget "river:#{r.site_no}", "discharge", "gauge_height", "water_temp", "turbidity", "weather", "updated_at"
      r.discharge    = d[0]
      r.gauge_height = d[1]
      r.water_temp   = d[2]
      r.turbidity    = d[3]
      r.weather      = d[4].present? ? JSON.parse(d[4]) : nil
      r.usgs_updated_at = d[5].present? ? d[5].to_time : nil
    end
  end

  def add_www_subdomain
    redirect_to 'https://www.riverboss.com' + request.fullpath, status: 301 if request.host == 'riverboss.com'
  end

end
