# Forces to reload Bootstrap modal on each access.
# Otherwise the modal contains the same content after it is invoked once.
#
$ ->
    $(document).on 'hidden.bs.modal', (e) ->
        # console?.log "bootstrap modal hidden:", e.target
        $(e.target).removeData 'bs.modal'
        $(e.target).find(".modal-content").empty()
