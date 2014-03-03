# Redefines submit behaviour for forms with +data-async+ attribute.
#
# On submit handler composes and sends AJAX request, renders result
# in an element specified by form's +data-target+ attribute.
#

$ ->
    $('form[data-async]').on 'submit', (event)->
        form = $(this)
        target = $(form.attr 'data-target')
        $.ajax
            type: form.attr 'method'
            url: form.attr 'action'
            data: form.serialize()
            error: (x, e, status ) ->
                console?.log "form-data-async submit error: #{e}, status: #{status}"
            success: (data, status) ->
                target.html data
        event.preventDefault()
