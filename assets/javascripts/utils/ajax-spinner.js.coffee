ajax_spinner = null

ajax_spinner_opts =
    lines: 13   # The number of lines to draw
    length: 7   # The length of each line
    width: 3    # The line thickness
    radius: 10  # The radius of the inner circle
    corners: 1  # Corner roundness (0..1)
    rotate: 0   # The rotation offset
    direction: 1    # 1: clockwise, -1: counterclockwise
    color: '#fff'   # #rgb or #rrggbb or array of colors
    speed: 1    # Rounds per second
    trail: 60   # Afterglow percentage
    shadow: false   # Whether to render a shadow
    hwaccel: false  # Whether to use hardware acceleration

# Shows ajax spinner in a +target+ element specified by selector.
#
( exports ? this ).ajax_spinner_show = (target) ->
    target = $(target).get( 0 )
    ajax_spinner = new Spinner( ajax_spinner_opts ).spin target

# Hides current ajax spinner.
#
( exports ? this ).ajax_spinner_hide = ->
    ajax_spinner.stop()