# Enables drag-and-drop functionality on passed SmartTreeTable
#

log = (msg) ->
    console?.log "** smart-tree-table-drag-n-drop: #{msg}"
error = (msg) ->
    console?.error "** smart-tree-table-drag-n-drop: #{msg}"
    throw new Error msg


class @SmartTreeTableDragAndDrop

    constructor: (@table) ->
        @settings = @table.settings.dragAndDrop
        @reset()
        @bind_draggables()



    # Resets inner structures.
    #
    reset: ->
        @helper = null
        @drag_over_row = null
        @drop_target = {}
        @drop_target_overlay = null
        @drag_start_row = null


    bind_draggables: ->
        draggable_options =
            addClasses: false
            appendTo: @table.table
            helper: ( @settings.helper || @create_drag_and_drop_helper )
            opacity: @settings.helperOpacity

            start: (e, ui) =>
                if @settings.handle
                    id = @table.id_of $(e.currentTarget).closest 'tr'
                else
                    id = @table.id_of $(e.currentTarget)
                @on_drag_start id

            stop: =>
                @on_drag_stop()

            drag: (e, ui) =>
                center_y = ui.helper.position().top + ui.helper.height()/2;
                @on_drag_evaluate center_y

        if @settings.handle?
            @table.table_html_rows().find(@settings.handle).draggable draggable_options
        else
            @table.table_html_rows().draggable draggable_options
        log "enabled, handle: #{if @settings.handle? then @settings.handle else 'all rows'}"

    # Callback to be invoked on drag start.
    #
    on_drag_start: (id) ->
        @drag_start_row = @table.rows[id]
        @table.select null
        @table.collapse id
        @drag_start_row.el.addClass @settings.dragSourceClass if @settings.dragSourceClass
        # validate drop targets
        @create_drop_target_overlay()
        log "started row #{id}"

    # Callback to be invoked on drag finish.
    #
    on_drag_stop: ->
        @destroy_drop_target_overlay()
        @drag_over_row.el.removeClass @settings.dragOverClass if @drag_over_row?
        @drag_start_row.el.removeClass @settings.dragSourceClass if @settings.dragSourceClass
        if @drop_target.id? && @drop_target.insert_mode != 'outside'
            @table.move_tree_node @drag_start_row.id, @drop_target.id, @drop_target.insert_mode
            log "finished: #{@drop_target.insert_mode}:#{@drop_target.id}"
        else
            log "finished outside of valid targets"
        @reset()


    # Callback to be invoked on each drag movement.
    # +y+ is the center position of the draggable helper.
    #
    on_drag_evaluate: (y) ->
        drag_over_table = false
        for id, row of @table.rows
            row_top = row.el.position().top
            row_bottom = row_top + row.el.height()
            if row_top < y && row_bottom > y
                drag_over_table = true
                @on_drag_over row, y-row_top, row_bottom-y
        @on_drag_over null, 0, 0 unless drag_over_table


    # Callback to be invoked on drag over table row,
    # +row+ is Row object or null if helper is dragged outside of the table
    # +before_px+ is the distance from row top to helper's +y+
    # +after_px+ is the distance from row bottom to helper's +y+
    #
    on_drag_over: (row, before_px, after_px) ->
        @drag_over_row.el.removeClass @settings.dragOverClass if @drag_over_row?
        @drag_over_row = row
        @drop_target = {}
        unless row?
            @hide_drop_target_overlay()
            return
        @drag_over_row.el.addClass @settings.dragOverClass
        unless @drag_start_row.id == row.id
            @drop_target.id = row.id
            @drop_target.row = row
            if before_px < @settings.dropTarget.beforePx
                @drop_target.insert_mode = 'before'
            else if after_px < @settings.dropTarget.afterPx
                @drop_target.insert_mode = 'after'
            else
                @drop_target.insert_mode = 'into'
        @update_drop_target_overlay row, @drop_target.insert_mode

    #
    #
    create_drag_and_drop_helper: (e) =>
        src = null
        if @settings.handle?
            src = $(e.currentTarget).closest 'tr'
        else
            src = $(e.currentTarget)
        helper = src.clone()
        helper.children().each (i) ->
            $(@).width src.children().eq(i).width()
        helper.width src.width()
        helper.height src.height()
        helper.addClass @settings.helperClass
        helper.removeClass "selected"
        log "helper created"
        helper

    # Create drop target overlay
    #
    create_drop_target_overlay: ->
        @drop_target_overlay = $( '<div>', { class: @settings.dropTarget.overlay.class } )
        @drop_target_overlay.css 'position', 'absolute'
        # @drop_target_overlay.css 'z-index', 100
        @table.table.find('tbody').append @drop_target_overlay
        @drop_target_overlay.text( "overlay created" )


    # Destroy drag target overlay
    #
    destroy_drop_target_overlay: ->
        @drop_target_overlay.remove() if @drop_target_overlay?

    # Hides drag_target_overlay
    #
    hide_drop_target_overlay: ->
        @drop_target_overlay.hide() if @drop_target_overlay?

    # Shows drop_target_overlay
    #
    show_drop_target_overlay: ->
        @drop_target_overlay.show() if @drop_target_overlay?

    # Updates drag target overlay.
    #
    update_drop_target_overlay: (row, insert_mode = 'outside' ) ->
        @show_drop_target_overlay()
        @drop_target_overlay.html ''
        if insert_mode == 'before'
            @drop_target_overlay.html @settings.dropTarget.overlay.before
        if insert_mode == 'into'
            @drop_target_overlay.html @settings.dropTarget.overlay.into
        if insert_mode == 'after'
            @drop_target_overlay.html @settings.dropTarget.overlay.after
        el_top = row.el.position().top
        el_left = row.el.position().left
        el_height = row.el.height()
        el_width = row.el.width()
        @drop_target_overlay.removeClass "before into after outside"
        @drop_target_overlay.addClass insert_mode
        @drop_target_overlay.css(
            top: el_top
            left: el_left
            height: el_height
            width: el_width
        )





