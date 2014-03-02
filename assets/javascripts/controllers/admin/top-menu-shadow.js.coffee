
$ ->
    $(window).scroll ->
        y = $(window).scrollTop()
        if y > 0
            $("#top-menu").addClass "has-shadow"
        else
            $("#top-menu").removeClass "has-shadow"
    console?.log "admin/top-menu-shadow loaded"