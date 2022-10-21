@module "RiverBoss", ->
  @module "General", ->

    @startPageLoading = ->
      $('.page-loading').addClass('show')

    @finishPageLoading = ->
      $('.page-loading').removeClass('show')

    # accordion menu init
    @initAccordion = ->
      jQuery(".accordion").slideAccordion
        addClassBeforeAnimation: true
        opener: ".open"
        slider: ".slide"
        animSpeed: 300

      return

    # mobile menu init
    @initMobileNav = ->
      jQuery("#wrapper").mobileNav
        hideOnClickOutside: true
        menuActiveClass: "active"
        menuOpener: ".opener"
        menuDrop: ".drop"

      return

    # handle fixed blocks position
    @initFixedBlocks = ->
      win = jQuery(window)
      blocks = jQuery("#header, #footer")
      fixPosition = ->
        scrollLeft = win.scrollLeft()
        blocks.css marginLeft: -scrollLeft
        return

      fixPosition()
      win.bind "scroll resize", fixPosition
      return


    @init = ->
      unless @initialized
        @initialized = true
        @initOnce()
      @ready()

      setCookie = (cname, cvalue, exdays) ->
        d = new Date()
        d.setTime d.getTime() + (exdays * 24 * 60 * 60 * 1000)
        expires = "expires=" + d.toGMTString()
        document.cookie = cname + "=" + cvalue + "; " + expires
        return

      getCookie = (cname) ->
        name = cname + "="
        ca = document.cookie.split(";")
        i = 0
        while i < ca.length
          c = ca[i]
          c = c.substring(1)  while c.charAt(0) is " "
          return c.substring(name.length, c.length)  if c.indexOf(name) is 0
          i++
        ""

      setGeoCookieAndRedirect = (position) ->
        cookie_val = position.coords.latitude + "|" + position.coords.longitude
        setCookie "lat_lng", escape(cookie_val), 2
        window.location.replace document.URL

      errorGeoFunction = (error) ->
        $('#modal_content').html ""
        $('.modal').fadeOut 200

      if navigator && navigator.geolocation && $("#html5_geolocation").length && getCookie("lat_lng") == ""
        $('#modal_content').html "We are trying to find rivers near you. For accurate results, please “Allow” if your browser asks for permission."
        $('.modal').fadeIn 200
        navigator.geolocation.getCurrentPosition setGeoCookieAndRedirect, errorGeoFunction, {enableHighAccuracy:true, timeout:3600, maximumAge:(2 * 24 * 60 * 60 * 1000)}

    @initOnce = ->
      # Spinners
      $(document).on 'page:fetch', (event) ->
        RiverBoss.General.startPageLoading()

      $(document).on 'page:change', (event) ->
        RiverBoss.General.finishPageLoading()

      $(document).on 'click', 'a[data-no-turbolink]', ->
        RiverBoss.General.startPageLoading()

      $(document).on 'submit', 'form', ->
        RiverBoss.General.startPageLoading()

      $(document).on "click", ".toggle_cfs_ft", ->
        $('.river_table .col2').toggleClass('tog')

      $(document).on "click", ".alert-close", (e) ->
        e.preventDefault()
        $(@).closest('.alert').slideUp 500

    @ready = ->
      $("input, textarea").placeholder()
      RiverBoss.General.initAccordion()
      RiverBoss.General.initMobileNav()
      RiverBoss.General.initFixedBlocks()

      $('.weather-forecast .col1').each ->
        $(@).next().addClass('night-weather') if $(@).find('a').text().indexOf("ight") > -1


jQuery ->
  RiverBoss.General.init()
