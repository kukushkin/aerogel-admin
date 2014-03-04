#
# Move 'submit' and 'cancel' buttons from Bootstrap modal's body to footer
#

admin_modal_replace_buttons = (el, target) ->
    # console?.log "Moving buttons around: #{$(el).size()}"
    $(el).each ->
        button = $(this)
        form = button.closest "form"
        target = form.closest('.modal-content').find target
        if button.attr('type') == 'submit'
            admin_modal_replace_submit_button button, form, target
        if button.attr('type') == 'cancel'
            admin_modal_replace_cancel_button button, form, target


# Process 'submit' button
#
admin_modal_replace_submit_button = (button, form, target) ->
    button.click ->
        form.submit()
    button.appendTo target
    enable_form_submit_on_enter form

# Process 'cancel' button
#
admin_modal_replace_cancel_button = (button, form, target) ->
    button.attr 'data-dismiss', 'modal'
    button.appendTo target



enable_form_submit_on_enter = (form) ->
    unless form.attr 'form-submit-on-enter-enabled'
        form.keypress (e) ->
            if e.keyCode == 13 && ( e.target.type != 'textarea' )
                e.preventDefault()
                $(this).submit()
        form.attr 'form-submit-on-enter-enabled', true
        # console?.log "Enabled form keypress"


$ ->
    admin_modal_replace_buttons ".modal-body .btn[type=submit], .modal-body .btn[type=cancel]", ".modal-footer"

