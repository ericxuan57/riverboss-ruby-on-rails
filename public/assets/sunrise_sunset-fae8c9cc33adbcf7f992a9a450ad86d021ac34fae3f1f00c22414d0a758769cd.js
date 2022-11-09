(function() {
  this.module("RiverBoss", function() {
    return this.module("SunriseSunset", function() {
      this.init = function() {
        var $detail;
        $detail = $('.sunrise-sunset');
        if ($detail.length) {
          return $detail.each(function() {
            var result;
            return result = RiverBoss.SunriseSunset.getSunriseSunset($(this).data('location'), $(this).find(".sunrise"), $(this).find(".sunset"));
          });
        }
      };
      return this.getSunriseSunset = function(location, $rise, $set) {
        var url;
        url = "https://query.yahooapis.com/v1/public/yql?q=select%20astronomy%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places%20where%20text%3D%22" + location + "%22)%3B&format=json";
        return $.getJSON(url, function(data) {
          var channel, result;
          if (data !== null && data.query !== null && data.query.results !== null && data.query.results.channel.description !== 'Yahoo! Weather Error') {
            channel = data.query.results.channel;
            result = Array.isArray(channel) ? channel[0].astronomy : channel.astronomy;
            $rise.text(result.sunrise);
            return $set.text(result.sunset);
          } else {
            return false;
          }
        });
      };
    });
  });

  jQuery(function() {
    return RiverBoss.SunriseSunset.init();
  });

}).call(this);
