(function() {
  this.module("RiverBoss", function() {
    return this.module("General", function() {
      this.initNav = function(o) {
        var a, arrow, d, fPX, i, j, lfl, li, n, t, w;
        fPX = function(a) {
          var b;
          b = 0;
          while (a.offsetParent) {
            b += a.offsetLeft;
            a = a.offsetParent;
          }
          return b;
        };
        if (!o.menuId) {
          o.menuId = "main-nav";
        }
        if (!o.cleverMode) {
          o.cleverMode = false;
        }
        if (!o.flexibility) {
          o.flexibility = false;
        }
        if (!o.dropExistenceClass) {
          o.dropExistenceClass = false;
        }
        if (!o.hoverClass) {
          o.hoverClass = "hover";
        }
        if (!o.menuHardCodeClass) {
          o.menuHardCodeClass = "menu-hard-code";
        }
        if (!o.sideClasses) {
          o.sideClasses = false;
        }
        if (!o.center) {
          o.center = false;
        }
        if (!o.menuPaddings) {
          o.menuPaddings = 0;
        }
        if (!o.minWidth) {
          o.minWidth = 0;
        }
        if (!o.coeff) {
          o.coeff = 1.7;
        }
        n = document.getElementById(o.menuId);
        if (n) {
          n.className = n.className.replace(o.menuHardCodeClass, "");
          lfl = [];
          li = n.getElementsByTagName("li");
          i = 0;
          while (i < li.length) {
            li[i].className += " " + o.hoverClass;
            d = li[i].getElementsByTagName("div").item(0);
            if (d) {
              if (o.flexibility) {
                a = d.getElementsByTagName("a");
                j = 0;
                while (j < a.length) {
                  w = a[j].parentNode.parentNode.offsetWidth;
                  if (w > 0) {
                    if (typeof o.minWidth === "number" && w < o.minWidth) {
                      w = o.minWidth;
                    } else {
                      if (typeof o.minWidth === "string" && li[i].parentNode === n && w < li[i].offsetWidth) {
                        w = li[i].offsetWidth - 5;
                      }
                    }
                    a[j].style.width = w - o.menuPaddings + "px";
                  }
                  j++;
                }
              }
              t = document.documentElement.clientWidth / o.coeff;
              if (li[i].parentNode !== n && (!o.cleverMode || fPX(li[i]) < t)) {
                d.style.right = "auto";
                d.style.left = li[i].parentNode.offsetWidth + "px";
                d.parentNode.className += " left-side";
              } else if (li[i].parentNode !== n && (o.cleverMode || fPX(li[i]) >= t)) {
                d.style.left = "auto";
                d.style.right = li[i].parentNode.offsetWidth + "px";
                d.parentNode.className += " right-side";
              } else {
                if (li[i].parentNode === n && o.cleverMode && fPX(li[i]) >= t) {
                  li[i].className += " right-side";
                }
              }
              if (li[i].parentNode === n && o.center) {
                d.style.left = -li[i].getElementsByTagName("div").item(1).clientWidth / 2 + li[i].clientWidth / 2 + "px";
              }
            }
            if (o.dropExistenceClass && li[i].getElementsByTagName("ul").length > 0) {
              li[i].className += " " + o.dropExistenceClass;
              li[i].getElementsByTagName("a").item(0).className += " " + o.dropExistenceClass + "-link";
              arrow = document.createElement("em");
              arrow.className = "pointer";
              li[i].appendChild(arrow);
            }
            if (li[i].parentNode === n) {
              lfl.push(li[i]);
            }
            i++;
          }
          if (o.sideClasses) {
            lfl[0].className += " first-child";
            lfl[0].getElementsByTagName("a").item(0).className += " first-child-link";
            lfl[lfl.length - 1].className += " last-child";
            lfl[lfl.length - 1].getElementsByTagName("a").item(0).className += " last-child-link";
          }
          i = 0;
          while (i < li.length) {
            li[i].className = li[i].className.replace(o.hoverClass, "");
            li[i].onmouseover = function() {
              this.className += " " + o.hoverClass;
            };
            li[i].onmouseout = function() {
              this.className = this.className.replace(o.hoverClass, "");
            };
            i++;
          }
        }
      };
      this.startPageLoading = function() {
        return $('.page-loading').addClass('show');
      };
      this.finishPageLoading = function() {
        return $('.page-loading').removeClass('show');
      };
      this.init = function() {
        if (!this.initialized) {
          this.initialized = true;
          this.initOnce();
        }
        return this.ready();
      };
      this.initOnce = function() {
        $(document).on('page:fetch', function(event) {
          return RiverBoss.General.startPageLoading();
        });
        $(document).on('page:change', function(event) {
          return RiverBoss.General.finishPageLoading();
        });
        $(document).on('click', 'a[data-no-turbolink]', function() {
          return RiverBoss.General.startPageLoading();
        });
        return $(document).on('submit', 'form', function() {
          return RiverBoss.General.startPageLoading();
        });
      };
      return this.ready = function() {
        $("input, textarea").placeholder();
        RiverBoss.General.initNav({
          menuId: "nav",
          dropExistenceClass: "drop-down",
          flexibility: true
        });
        if ($('.alert').length) {
          setTimeout(function() {
            return $('.alert').fadeIn(250, function() {
              return $(this).remove();
            });
          }, 5000);
        }
        $('.river-graph-show').mouseenter(function() {
          return $(this).closest('td').find('.river-graph').fadeIn(100);
        });
        return $('.river-graph-show').mouseleave(function() {
          return $(this).closest('td').find('.river-graph').fadeOut(100);
        });
      };
    });
  });

  jQuery(function() {
    return RiverBoss.General.init();
  });

}).call(this);
