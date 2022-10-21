@module "RiverBoss", ->
  @module "General", ->

    @initNav = (o) ->
      fPX = (a) ->
        b = 0
        while a.offsetParent
          b += a.offsetLeft
          a = a.offsetParent
        b
      o.menuId = "main-nav"  unless o.menuId
      o.cleverMode = false  unless o.cleverMode
      o.flexibility = false  unless o.flexibility
      o.dropExistenceClass = false  unless o.dropExistenceClass
      o.hoverClass = "hover"  unless o.hoverClass
      o.menuHardCodeClass = "menu-hard-code"  unless o.menuHardCodeClass
      o.sideClasses = false  unless o.sideClasses
      o.center = false  unless o.center
      o.menuPaddings = 0  unless o.menuPaddings
      o.minWidth = 0  unless o.minWidth
      o.coeff = 1.7  unless o.coeff
      n = document.getElementById(o.menuId)
      if n
        n.className = n.className.replace(o.menuHardCodeClass, "")
        lfl = []
        li = n.getElementsByTagName("li")
        i = 0

        while i < li.length
          li[i].className += (" " + o.hoverClass)
          d = li[i].getElementsByTagName("div").item(0)
          if d
            if o.flexibility
              a = d.getElementsByTagName("a")
              j = 0

              while j < a.length
                w = a[j].parentNode.parentNode.offsetWidth
                if w > 0
                  if typeof (o.minWidth) is "number" and w < o.minWidth
                    w = o.minWidth
                  else w = li[i].offsetWidth - 5  if typeof (o.minWidth) is "string" and li[i].parentNode is n and w < li[i].offsetWidth
                  a[j].style.width = w - o.menuPaddings + "px"
                j++
            t = document.documentElement.clientWidth / o.coeff
            if li[i].parentNode isnt n and (not o.cleverMode or fPX(li[i]) < t)
              d.style.right = "auto"
              d.style.left = li[i].parentNode.offsetWidth + "px"
              d.parentNode.className += " left-side"
            else if li[i].parentNode isnt n and (o.cleverMode or fPX(li[i]) >= t)
              d.style.left = "auto"
              d.style.right = li[i].parentNode.offsetWidth + "px"
              d.parentNode.className += " right-side"
            else li[i].className += " right-side"  if li[i].parentNode is n and o.cleverMode and fPX(li[i]) >= t
            d.style.left = -li[i].getElementsByTagName("div").item(1).clientWidth / 2 + li[i].clientWidth / 2 + "px"  if li[i].parentNode is n and o.center
          if o.dropExistenceClass and li[i].getElementsByTagName("ul").length > 0
            li[i].className += (" " + o.dropExistenceClass)
            li[i].getElementsByTagName("a").item(0).className += (" " + o.dropExistenceClass + "-link")
            arrow = document.createElement("em")
            arrow.className = "pointer"
            li[i].appendChild arrow
          lfl.push li[i]  if li[i].parentNode is n
          i++
        if o.sideClasses
          lfl[0].className += " first-child"
          lfl[0].getElementsByTagName("a").item(0).className += " first-child-link"
          lfl[lfl.length - 1].className += " last-child"
          lfl[lfl.length - 1].getElementsByTagName("a").item(0).className += " last-child-link"
        i = 0

        while i < li.length
          li[i].className = li[i].className.replace(o.hoverClass, "")
          li[i].onmouseover = ->
            @className += (" " + o.hoverClass)
            return

          li[i].onmouseout = ->
            @className = @className.replace(o.hoverClass, "")
            return
          i++
      return

    @startPageLoading = ->
      $('.page-loading').addClass('show')

    @finishPageLoading = ->
      $('.page-loading').removeClass('show')

    @init = ->
      unless @initialized
        @initialized = true
        @initOnce()
      @ready()

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

    @ready = ->
      $("input, textarea").placeholder()

      RiverBoss.General.initNav
        menuId: "nav"
        dropExistenceClass: "drop-down"
        flexibility: true

      if $('.alert').length
        setTimeout ->
          $('.alert').fadeIn 250, ->
            $(@).remove()
        , 5000

      $('.river-graph-show').mouseenter ->
        $(@).closest('td').find('.river-graph').fadeIn 100
      $('.river-graph-show').mouseleave ->
        $(@).closest('td').find('.river-graph').fadeOut 100


jQuery ->
  RiverBoss.General.init()
