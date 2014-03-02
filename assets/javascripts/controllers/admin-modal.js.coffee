# Redefines submit behaviour for forms with +data-async+ attribute.
#
# On submit handler composes and sends AJAX request, renders result
# in an element specified by form's +data-target+ attribute.
#

$ ->
    $('form[data-async]').on 'submit', (event)->
        form = $(this)
        target = $(form.attr 'data-target')
        console?.log "async form submit: #{target}"
        $.ajax
            type: form.attr 'method'
            url: form.attr 'action'
            data: form.serialize()
            error: (x, e, status ) ->
                console?.log "error: #{e}"
                console?.log "status: #{status}"
            success: (data, status) ->
                console?.log "async form result: #{status}"
                console?.log "target: #{target}"
                console?.log "data: #{data}"
                target.html data
        event.preventDefault()
    console?.log "async form submission enabled"
