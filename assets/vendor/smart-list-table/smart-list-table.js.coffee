#= require ./smart-list-table-row
#
debug = false
log = (msg) ->
    console?.log "** smart-list-table: #{msg}" if debug
error = (msg) ->
    console?.error "** smart-list-table: #{msg}" if debug
    throw new Error msg

class @SmartListTable

    # Default settings
    @_default_settings:
        column: 1
        addClass: 'smart-list-table'
        selectedClass: "selected"
        hoverClass: null # or class to add on mouseenter/mouseleave
        dragAndDrop:
            enabled: false
            handle: null # or selector to drag-n-drop handle
            helper: null # or function returning helper element
            helperClass: 'drag-helper'
            helperOpacity: 0.85
            dragOverClass: 'drag-over'
            dragSourceClass: 'drag-source'
            dropTarget:
                beforePx: 7
                afterPx: 10
                overlay:
                    class: "drop-target-overlay"
                    before: '' # contents for 'before' insert mode
                    into: ''   # contents for 'into' insert mode
                    after: ''  # contents for 'after' insert mode
        debug: false
        on_select: null

    # Creates a SmartTreeTable object using an HTML table specified by +el+ selector.
    #
    constructor: (el, options = {}) ->
        unless $(el).length > 0
            error "No matching elements specified by selector '#{el}'"
        @settings = $.extend true, SmartListTable._default_settings, options
        @settings.active_column_selector = "td:nth-child(#{@settings.column})"
        @table = $(el).first()
        @table.addClass @settings.addClass if @settings.addClass?
        @init_table_rows()
        @bind_event_listeners()
        @selected_row = null
        @drag_and_drop = null
        $(el).disableSelection()
        # SmartListTable object ready
        #
        # @enable_drag_and_drop() if @settings.dragAndDrop.enabled
        log "created SmartListTable: #{el}"


    #
    # private methods
    #

    # Returns SmartListTable rows as list.
    #
    table_html_rows: ->
        @table.find('tbody tr')

    # Returns table row ids as list.
    #
    table_html_row_ids: ->
        @id_of(row) for row in @table_html_rows()

    # Returns Rows as list, ordered as the table.
    #
    rows_list: ->
        @rows[id] for id in @table_html_row_ids()

    # Returns +id+ of a given row HTML element.
    #
    id_of: (el) ->
        $(el).attr 'data-id'

    # initializes table rows
    #
    init_table_rows: ->
        @rows = {}
        for row in @table_html_rows()
            row_obj = new SmartListTableRow @, $(row)
            row_obj.expanded = true
            @rows[row_obj.id] = row_obj

        @update_table_rows()
        #for row in @rows_list()
        #    @collapse row.id
            # log "row: #{row.id} -> #{row.parent_id} (level:#{row.level}): #{row.contents}"


    # Updates table rows.
    # Sets level, branch/leaf properties.
    #
    update_table_rows: ->
        # nothing


    # Selects row with +id+.
    #
    select: (id, process_callbacks = true ) ->
        @selected_row.selected = false if @selected_row?
        @selected_row = null
        @selected_row = @rows[id] if id?
        @selected_row.selected = true if @selected_row?
        # if parent is collapsed, expand all until first expanded ancestor

        if @settings.on_select? && process_callbacks
            selected_id = if @selected_row? then @selected_row.id else null
            selected_el = if @selected_row? then @selected_row.el else null
            @settings.on_select selected_id, @selected_row, selected_el


    # Binds event listeners on rows.
    #
    bind_event_listeners: ->
        @table.find('tbody').on 'click', 'tr', (e) =>
            id = @id_of $(e.currentTarget)
            @select id

        if @settings.hoverClass?
            @table.find('tbody').on 'mouseenter', 'tr', (e) =>
                $(e.currentTarget).addClass @settings.hoverClass
            @table.find('tbody').on 'mouseleave', 'tr', (e) =>
                $(e.currentTarget).removeClass @settings.hoverClass


$ ->
    log "initialized"
