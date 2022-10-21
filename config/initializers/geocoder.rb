Geocoder.configure(
  lookup: :bing,
  api_key: ENV['BING_GEOCODE_ID'],
  ip_lookup: :ipapi_com,
  cache: Rails.cache,
  timeout: 5
)
