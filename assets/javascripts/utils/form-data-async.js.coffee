# Redefines submit behaviour for forms with +data-async+ attribute.
#
# On submit handler composes and sends AJAX request, renders result
# in an element specified by form's +data-target+ attribute.
#


( exports ? this ).form_data_async_enable = (el, target) ->
    $(el).on 'submit', (event)->
        form = $(this)
        $.ajax
            type: form.attr 'method'
            url: form.attr 'action'
            data: form.serialize()
            error: (x, e, status ) ->
                console?.log "form-data-async submit error: #{e}, status: #{status}"
            success: (data, status, xhr) ->
                content_type = xhr.getResponseHeader 'content-type'
                if /^text\/html/.test content_type
                    $(target).empty()
                    $(target).html data
                else
                    console?.log "form-data-async ignoring content: #{content_type}"

        event.preventDefault()
    console?.log "form-data-async enabled for #{el}, target:#{target}"

$ ->
    console?.log "form-data-async loaded"
