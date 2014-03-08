
$ ->
    $(document).bind "ajaxStart", ->
        console?.log "** ajax-watcher: start"
        $("#ajax-indicator").show()
        console?.log "** ajax-watcher: showing indicator"
    $(document).bind "ajaxStop", ->
        console?.log "** ajax-watcher: stop"
        $("#ajax-indicator").hide()
    console?.log "** ajax-watcher: initialized"