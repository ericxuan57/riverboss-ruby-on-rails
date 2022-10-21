/*
 * jQuery Accordion plugin
 */
;(function($){
  $.fn.slideAccordion = function(opt){
    // default options
    var options = $.extend({
      addClassBeforeAnimation: false,
      allowClickWhenExpanded: false,
      activeClass:'active',
      opener:'.opener',
      slider:'.slide',
      animSpeed: 300,
      collapsible:true,
      event:'click'
    },opt);

    return this.each(function(){
      // options
      var accordion = $(this);
      var items = accordion.find(':has('+options.slider+')');

      items.each(function(){
        var item = $(this);
        var opener = item.find(options.opener);
        var slider = item.find(options.slider);
        opener.bind(options.event, function(e){
          if(!slider.is(':animated')) {
            if(item.hasClass(options.activeClass)) {
              if(options.allowClickWhenExpanded) {
                return;
              } else if(options.collapsible) {
                slider.slideUp(options.animSpeed, function(){
                  hideSlide(slider);
                  item.removeClass(options.activeClass);
                });
              }
            } else {
              // show active
              var levelItems = item.siblings('.'+options.activeClass);
              var sliderElements = levelItems.find(options.slider);
              item.addClass(options.activeClass);
              showSlide(slider).hide().slideDown(options.animSpeed);

              // collapse others
              sliderElements.slideUp(options.animSpeed, function(){
                levelItems.removeClass(options.activeClass);
                hideSlide(sliderElements);
              });
            }
          }
          e.preventDefault();
        });
        if(item.hasClass(options.activeClass)) showSlide(slider); else hideSlide(slider);
      });
    });
  };

  // accordion slide visibility
  var showSlide = function(slide) {
    return slide.css({position:'', top: '', left: '', width: '' });
  };
  var hideSlide = function(slide) {
    return slide.show().css({position:'absolute', top: -9999, left: -9999, width: slide.width() });
  };
}(jQuery));

/*
 * Simple Mobile Navigation
 */
;(function($) {
  function MobileNav(options) {
    this.options = $.extend({
      container: null,
      hideOnClickOutside: false,
      menuActiveClass: 'nav-active',
      menuOpener: '.nav-opener',
      menuDrop: '.nav-drop',
      toggleEvent: 'click',
      outsideClickEvent: 'click touchstart pointerdown MSPointerDown'
    }, options);
    this.initStructure();
    this.attachEvents();
  }
  MobileNav.prototype = {
    initStructure: function() {
      this.page = $('html');
      this.container = $(this.options.container);
      this.opener = this.container.find(this.options.menuOpener);
      this.drop = this.container.find(this.options.menuDrop);
    },
    attachEvents: function() {
      var self = this;

      if(activateResizeHandler) {
        activateResizeHandler();
        activateResizeHandler = null;
      }

      this.outsideClickHandler = function(e) {
        if(self.isOpened()) {
          var target = $(e.target);
          if(!target.closest(self.opener).length && !target.closest(self.drop).length) {
            self.hide();
          }
        }
      };

      this.openerClickHandler = function(e) {
        e.preventDefault();
        self.toggle();
      };

      this.opener.on(this.options.toggleEvent, this.openerClickHandler);
    },
    isOpened: function() {
      return this.container.hasClass(this.options.menuActiveClass);
    },
    show: function() {
      this.container.addClass(this.options.menuActiveClass);
      if(this.options.hideOnClickOutside) {
        this.page.on(this.options.outsideClickEvent, this.outsideClickHandler);
      }
    },
    hide: function() {
      this.container.removeClass(this.options.menuActiveClass);
      if(this.options.hideOnClickOutside) {
        this.page.off(this.options.outsideClickEvent, this.outsideClickHandler);
      }
    },
    toggle: function() {
      if(this.isOpened()) {
        this.hide();
      } else {
        this.show();
      }
    },
    destroy: function() {
      this.container.removeClass(this.options.menuActiveClass);
      this.opener.off(this.options.toggleEvent, this.clickHandler);
      this.page.off(this.options.outsideClickEvent, this.outsideClickHandler);
    }
  };

  var activateResizeHandler = function() {
    var win = $(window),
      doc = $('html'),
      resizeClass = 'resize-active',
      flag, timer;
    var removeClassHandler = function() {
      flag = false;
      doc.removeClass(resizeClass);
    };
    var resizeHandler = function() {
      if(!flag) {
        flag = true;
        doc.addClass(resizeClass);
      }
      clearTimeout(timer);
      timer = setTimeout(removeClassHandler, 500);
    };
    win.on('resize orientationchange', resizeHandler);
  };

  $.fn.mobileNav = function(options) {
    return this.each(function() {
      var params = $.extend({}, options, {container: this}),
        instance = new MobileNav(params);
      $.data(this, 'MobileNav', instance);
    });
  };
}(jQuery));