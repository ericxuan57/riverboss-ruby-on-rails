@module "RiverBoss", ->
  @module "ManageRivers", ->

    @initOnce = ->
      $(document).on 'ajax:success', '#save_my_river_form', (e, xhr) ->
        if xhr["status"] == 'failure'
          $('#modal_content').html "<h2>Something went wrong, please refresh page and try again!</h2>"
          RiverBoss.General.finishPageLoading()
          return
        RiverBoss.ManageRivers.sendAjaxRequestForCondition xhr["url"]

    @imgError = (img) ->
      width = $(img).attr('width') || parseInt($(img).css('width'))
      if !width
        $(img).attr('src', "https://placehold.it/#{500}/eee&text=No+Image")
      else if width > 75
        $(img).attr('src', "https://placehold.it/#{width}/eee&text=No+Image")
      else
        $(img).attr('src', $('#not_available').attr('src'))

    @init = ->
      unless @initialized
        @initialized = true
        @initOnce()

      imgLoad = imagesLoaded("#main")
      imgLoad.on "always", ->
        for image in imgLoad.images
          RiverBoss.ManageRivers.imgError(image.img) unless image.isLoaded

      $('.river-autocomplete').autocomplete
        source: (request, response) ->
          $.ajax
            url: $('.river-autocomplete').data('url')
            dataType: "json"
            data: {q: request.term}
            success: (data) ->
              response data.map (d) ->
                {label: d[1], value: d[1], id: d[0]}
            beforeSend: ->
              $('.spinner').addClass('show')
            complete: ->
              $('.spinner').removeClass('show')
        minLength: 3
        select: (event, ui) ->
          if $(event.target).hasClass "auto-submit"
            $("#search_input_field").val(ui.item.value)
            $("#search_form").submit()

      $('#add_rivers_search').keyup ->
        val = $(@).val()
        if val.length > 2
          url = $(@).data('url') + "?q=#{val}"
          $.ajax
            url: url
            type: "GET"
            dataType: 'json'
            beforeSend: ->
              $('.spinner').addClass('show')
            complete: ->
              $('.spinner').removeClass('show')
            success:(data) ->
              $('#add_river_result').html null
              if data.length
                $.each( data, (i, v) ->
                  $('#add_river_result').append tmpl( "add_river_result_tmpl", {river_id: v[0], river_name: v[1]} )
                )
              else
                $('#add_river_result').html "<h3>Sorry we coundn't find any river.</h3>"

      $('#search_input_field_mobile').keyup ->
        val = $(@).val()
        if val.length > 2
          url = $(@).data('url') + "?q=#{val}"
          $.ajax
            url: url
            type: "GET"
            dataType: 'json'
            beforeSend: ->
              $('.spinner').addClass('show')
            complete: ->
              $('.spinner').removeClass('show')
            success:(data) ->
              $('#search_result_wrap').html null
              if data.length
                $.each( data, (i, v) ->
                  $('#search_result_wrap').append tmpl( "search_river_result_tmpl", {river_id: v[0], river_name: v[1]} )
                )

      $("#add_river_result.draggable").sortable
        axis: "y"
        dropOnEmpty: false
        handle: ".drag-handle"
        cursor: "crosshair"
        items: "div.river"
        opacity: 0.4
        scroll: true
        placeholder: "sortable-placeholder"
        update: ->
          $.ajax
            type: "post"
            data: $(@).sortable("serialize")
            dataType: "script"
            url: "/users_rivers/sort"

      RiverBoss.ManageRivers.initConditionFilter($("#condition_filter"))

      $('.condition-modal').on 'click', (e) ->
        url = $(@).data('url')
        return unless url
        e.preventDefault()
        RiverBoss.ManageRivers.sendAjaxRequestForCondition url

      $('#modal_close').on 'click', (e) ->
        $('.modal').fadeOut 200

    @sendAjaxRequestForCondition = (url) ->
      $.ajax
        url: url + "?redirect_to=#{window.location.pathname}"
        dataType: "json"
        success: (data) ->
          $('#modal_content').html data["result"]
          RiverBoss.ManageRivers.initConditionFilter($("#condition_filter"))
          $('.modal').fadeIn 200
        beforeSend: ->
          RiverBoss.General.startPageLoading()
        complete: ->
          RiverBoss.General.finishPageLoading()

    @initConditionFilter = ($conditionFilter) ->
      lowValue  = $conditionFilter.data('low-value')  || 300
      highValue = $conditionFilter.data('high-value') || 3000
      $conditionFilter.slider
        range: true
        min: 0
        max: 10000
        values: [lowValue, highValue]
        step: 1
        slide: (event, ui) ->
          $("#river_condition_low").val ui.values[0]
          $("#river_condition_high").val ui.values[1]
          return


jQuery ->
  RiverBoss.ManageRivers.init()
