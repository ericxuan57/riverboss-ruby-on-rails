@module "RiverBoss", ->
  @module "SunriseSunset", ->

    @init = ->
      $detail = $('.sunrise-sunset')
      if $detail.length
        $detail.each ->
          result = RiverBoss.SunriseSunset.getSunriseSunset $(@).data('location'), $(@).find(".sunrise"), $(@).find(".sunset")

    @getSunriseSunset = (location, $rise, $set) ->
      url = "https://query.yahooapis.com/v1/public/yql?q=select%20astronomy%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places%20where%20text%3D%22#{location}%22)%3B&format=json"
      $.getJSON url, (data) ->
        if(data != null && data.query != null && data.query.results != null && data.query.results.channel.description != 'Yahoo! Weather Error')
          channel = data.query.results.channel
          result = if Array.isArray(channel) then channel[0].astronomy else channel.astronomy
          $rise.text result.sunrise
          $set.text result.sunset
        else
          false

jQuery ->
  RiverBoss.SunriseSunset.init()
