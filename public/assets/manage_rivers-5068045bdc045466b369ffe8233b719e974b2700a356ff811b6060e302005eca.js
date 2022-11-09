(function() {
  this.module("RiverBoss", function() {
    return this.module("ManageRivers", function() {
      this.initOnce = function() {
        return $(document).on('ajax:success', '#save_my_river_form', function(e, xhr) {
          if (xhr["status"] === 'failure') {
            $('#modal_content').html("<h2>Something went wrong, please refresh page and try again!</h2>");
            RiverBoss.General.finishPageLoading();
            return;
          }
          return RiverBoss.ManageRivers.sendAjaxRequestForCondition(xhr["url"]);
        });
      };
      this.imgError = function(img) {
        var width;
        width = $(img).attr('width') || parseInt($(img).css('width'));
        if (!width) {
          return $(img).attr('src', "https://placehold.it/" + 500 + "/eee&text=No+Image");
        } else if (width > 75) {
          return $(img).attr('src', "https://placehold.it/" + width + "/eee&text=No+Image");
        } else {
          return $(img).attr('src', $('#not_available').attr('src'));
        }
      };
      this.init = function() {
        var imgLoad;
        if (!this.initialized) {
          this.initialized = true;
          this.initOnce();
        }
        imgLoad = imagesLoaded("#main");
        imgLoad.on("always", function() {
          var image, j, len, ref, results;
          ref = imgLoad.images;
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            image = ref[j];
            if (!image.isLoaded) {
              results.push(RiverBoss.ManageRivers.imgError(image.img));
            } else {
              results.push(void 0);
            }
          }
          return results;
        });
        $('.river-autocomplete').autocomplete({
          source: function(request, response) {
            return $.ajax({
              url: $('.river-autocomplete').data('url'),
              dataType: "json",
              data: {
                q: request.term
              },
              success: function(data) {
                return response(data.map(function(d) {
                  return {
                    label: d[1],
                    value: d[1],
                    id: d[0]
                  };
                }));
              },
              beforeSend: function() {
                return $('.spinner').addClass('show');
              },
              complete: function() {
                return $('.spinner').removeClass('show');
              }
            });
          },
          minLength: 3,
          select: function(event, ui) {
            if ($(event.target).hasClass("auto-submit")) {
              $("#search_input_field").val(ui.item.value);
              return $("#search_form").submit();
            }
          }
        });
        $('#add_rivers_search').keyup(function() {
          var url, val;
          val = $(this).val();
          if (val.length > 2) {
            url = $(this).data('url') + ("?q=" + val);
            return $.ajax({
              url: url,
              type: "GET",
              dataType: 'json',
              beforeSend: function() {
                return $('.spinner').addClass('show');
              },
              complete: function() {
                return $('.spinner').removeClass('show');
              },
              success: function(data) {
                $('#add_river_result').html(null);
                if (data.length) {
                  return $.each(data, function(i, v) {
                    return $('#add_river_result').append(tmpl("add_river_result_tmpl", {
                      river_id: v[0],
                      river_name: v[1]
                    }));
                  });
                } else {
                  return $('#add_river_result').html("<h3>Sorry we coundn't find any river.</h3>");
                }
              }
            });
          }
        });
        $('#search_input_field_mobile').keyup(function() {
          var url, val;
          val = $(this).val();
          if (val.length > 2) {
            url = $(this).data('url') + ("?q=" + val);
            return $.ajax({
              url: url,
              type: "GET",
              dataType: 'json',
              beforeSend: function() {
                return $('.spinner').addClass('show');
              },
              complete: function() {
                return $('.spinner').removeClass('show');
              },
              success: function(data) {
                $('#search_result_wrap').html(null);
                if (data.length) {
                  return $.each(data, function(i, v) {
                    return $('#search_result_wrap').append(tmpl("search_river_result_tmpl", {
                      river_id: v[0],
                      river_name: v[1]
                    }));
                  });
                }
              }
            });
          }
        });
        $("#add_river_result.draggable").sortable({
          axis: "y",
          dropOnEmpty: false,
          handle: ".drag-handle",
          cursor: "crosshair",
          items: "div.river",
          opacity: 0.4,
          scroll: true,
          placeholder: "sortable-placeholder",
          update: function() {
            return $.ajax({
              type: "post",
              data: $(this).sortable("serialize"),
              dataType: "script",
              url: "/users_rivers/sort"
            });
          }
        });
        RiverBoss.ManageRivers.initConditionFilter($("#condition_filter"));
        $('.condition-modal').on('click', function(e) {
          var url;
          url = $(this).data('url');
          if (!url) {
            return;
          }
          e.preventDefault();
          return RiverBoss.ManageRivers.sendAjaxRequestForCondition(url);
        });
        return $('#modal_close').on('click', function(e) {
          return $('.modal').fadeOut(200);
        });
      };
      this.sendAjaxRequestForCondition = function(url) {
        return $.ajax({
          url: url + ("?redirect_to=" + window.location.pathname),
          dataType: "json",
          success: function(data) {
            $('#modal_content').html(data["result"]);
            RiverBoss.ManageRivers.initConditionFilter($("#condition_filter"));
            return $('.modal').fadeIn(200);
          },
          beforeSend: function() {
            return RiverBoss.General.startPageLoading();
          },
          complete: function() {
            return RiverBoss.General.finishPageLoading();
          }
        });
      };
      return this.initConditionFilter = function($conditionFilter) {
        var highValue, lowValue;
        lowValue = $conditionFilter.data('low-value') || 300;
        highValue = $conditionFilter.data('high-value') || 3000;
        return $conditionFilter.slider({
          range: true,
          min: 0,
          max: 10000,
          values: [lowValue, highValue],
          step: 1,
          slide: function(event, ui) {
            $("#river_condition_low").val(ui.values[0]);
            $("#river_condition_high").val(ui.values[1]);
          }
        });
      };
    });
  });

  jQuery(function() {
    return RiverBoss.ManageRivers.init();
  });

}).call(this);
