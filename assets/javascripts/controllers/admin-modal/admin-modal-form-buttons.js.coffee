#
# Move 'submit' and 'cancel' buttons from Bootstrap modal's body to footer
#

admin_modal_replace_buttons = (el, target) ->
    # console?.log "Moving buttons around: #{$(el).size()}"
    $(el).each ->
        button = $(this)
        form = button.closest "form"
        target = form.closest('.modal-content').find target
        button.click ->
            form.submit()
        button.appendTo target
        # console?.log "Moving button: #{button.attr 'type'}:'#{button.text()}' -> #{target}"
        enable_form_submit_on_enter form


enable_form_submit_on_enter = (form) ->
    unless form.attr 'form-submit-on-enter-enabled'
        form.keypress (e) ->
            if e.keyCode == 13 && ( e.target.type != 'textarea' )
                e.preventDefault()
                $(this).submit()
        form.attr 'form-submit-on-enter-enabled', true
        # console?.log "Enabled form keypress"


$ ->
    admin_modal_replace_buttons ".modal-body button[type=submit], .modal-body button[type=cancel]", ".modal-footer"

