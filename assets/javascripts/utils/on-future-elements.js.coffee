# Applies +func+ to elements selected by +el+ on _each_ DOM insertion.
#
# Example:
#   on_future_elements "select.selectize:not(.selectize-applied)", (e) ->
#       $(e).selectize()
#       $(e).addClass "selectize-applied"
#
( exports ? this ).on_future_elements = (el, func) ->
    $(document).on 'DOMNodeInserted', (e) ->
        $(el).each ->
            func( this )


#$(document).on 'DOMNodeInserted', 'input', (e) ->
#    console?.log "** select2ify: element loaded"
