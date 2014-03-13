$ ->
    console?.log "** selectize-inputs: initialized"

on_future_elements 'select.selectize:not(.selectize-applied)', (e) ->
    console?.log "** selectize-inputs: element observed:", $(e).get(0).tagName
    $(e).addClass('selectize-applied')
    $(e).selectize();
