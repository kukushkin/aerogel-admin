
show_global_ajax_indicator = ->
    $("#ajax-indicator").show()
    ajax_spinner_show "#ajax-indicator .ajax-indicator-inner"

hide_global_ajax_indicator = ->
    ajax_spinner_hide()
    $("#ajax-indicator").hide()


$ ->
    $(document).bind "ajaxStart", ->
        console?.log "** ajax-watcher: start"
        show_global_ajax_indicator()
    $(document).bind "ajaxStop", ->
        console?.log "** ajax-watcher: stop"
        hide_global_ajax_indicator()
    console?.log "** ajax-watcher: initialized"