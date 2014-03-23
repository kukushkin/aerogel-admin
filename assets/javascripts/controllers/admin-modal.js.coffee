#= require utils/form-data-async
#= require_tree ./admin-modal

$ ->
    # console?.log "/admin/admin-modal enabling async forms: data-target: .modal-content"
    form_data_async_enable $(".modal-content FORM"), ".modal-content"
    console?.log "** admin/modal loaded"