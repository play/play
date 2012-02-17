# Scales the base 720p design to other 16:9 aspect ratios using a zoom
# declaration on the root <html> element.
$window = $(window)
zoom = ->
  ratio = $window.width() / $window.height()
  if ratio == 16 / 9 or location.search.indexOf('tv=1') > -1
    # scale up based on the available height. since the screen ratio is 16:9 the
    # width should line up perfectly.
    $('html').css zoom: $window.height() / 720
  else
    $('html').css zoom: 1.0

# zoom right now
zoom()
