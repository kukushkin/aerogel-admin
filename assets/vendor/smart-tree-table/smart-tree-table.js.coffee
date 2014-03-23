#= require ./smart-tree-table-row
#= require ./smart-tree-table-drag-n-drop
#

log = (msg) ->
    console?.log "** smart-tree-table: #{msg}"
error = (msg) ->
    console?.error "** smart-tree-table: #{msg}"
    throw new Error msg

class @SmartTreeTable



    # Default settings
    @_default_settings:
        column: 1
        indent: 20
        addClass: 'smart-tree-table'
        selectedClass: "selected"
        hoverClass: null # or class to add on mouseenter/mouseleave
        prefix:
            branch:
                expanded: "- "
                collapsed: "+ "
            leaf:
                expanded: ""
                collapsed: ""
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
        @settings = $.extend true, SmartTreeTable._default_settings, options
        @settings.active_column_selector = "td:nth-child(#{@settings.column})"
        @table = $(el).first()
        @table.addClass @settings.addClass if @settings.addClass?
        @init_table_rows()
        @bind_event_listeners()
        @selected_row = null
        @drag_and_drop = null
        $(el).disableSelection()
        # SmartTreeTable object ready
        #
        @enable_drag_and_drop() if @settings.dragAndDrop.enabled
        log "created SmartTreeTable: #{el}"


    #
    # private methods
    #

    # Returns table rows as list.
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

    # Returns list of children of parent with +id+.
    #
    children_of: (_id) ->
        # log "children_of(#{_id}) #{typeof @rows}"
        row for row in @rows_list() when row.parent_id == _id
        # row for id, row of @rows when row.parent_id == _id

    # Returns +id+ of a given row HTML element.
    #
    id_of: (el) ->
        $(el).attr 'data-id'

    # initializes table rows
    #
    init_table_rows: ->
        @rows = {}
        for row in @table_html_rows()
            row_obj = new SmartTreeTableRow @, $(row)
            row_obj.expanded = true
            @rows[row_obj.id] = row_obj

        @update_table_rows()
        for row in @rows_list()
            @collapse row.id
            # log "row: #{row.id} -> #{row.parent_id} (level:#{row.level}): #{row.contents}"


    # Updates table rows.
    # Sets level, branch/leaf properties.
    #
    update_table_rows: ->
        for row in @rows_list()
            if row.parent_id?
                row.level = @rows[row.parent_id].level + 1
            else
                row.level = 0
            children = @children_of( row.id )
            if children.length > 0
                row.branch = true
            else
                row.branch = false
            # log "row: #{row.id}, branch:#{row.branch}, children: #{children.length}"


    # Collapses row with given +id+.
    #
    collapse: (id) ->
        for row in @children_of(id)
            @collapse row.id
            row.hide()
        @rows[id].expanded = false

    # Expands row with given +id+.
    #
    expand: (id) ->
        for row in @children_of(id)
            row.show()
        @rows[id].expanded = true

    # Toggles collapsed/expanded row with +id+
    #
    toggle: (id) ->
        if @rows[id].expanded
            @collapse id
        else
            @expand id

    # Selects row with +id+.
    #
    select: (id) ->
        @selected_row.selected = false if @selected_row?
        return unless id?
        @selected_row = @rows[id]
        @selected_row.selected = true
        # if parent is collapsed, expand all until first expanded ancestor
        if @selected_row.parent_id?
            parent_id = @selected_row.parent_id
            while parent_id? && not @rows[parent_id].expanded
                @expand parent_id
                parent_id = @rows[parent_id].parent_id

        if @settings.on_select?
            @settings.on_select id, @selected_row, @selected_row.el


    # Binds event listeners on rows.
    #
    bind_event_listeners: ->
        @table.find('tbody').on 'click', 'tr', (e) =>
            id = @id_of $(e.currentTarget)
            @select id

        @table.find('tbody').on 'click', "tr #{@settings.active_column_selector}", (e) =>
            id = @id_of $(e.currentTarget).closest('tr')
            @toggle id

            # this line of code below miraculously prevents event from
            # not being propagated further, to "on 'click', 'tr'"
            # (Chrome 33.0, jQuery 2.0.3)
            tmp = "#{e.isPropagationStopped()}"
            # log "column click: e stopped:#{e.isPropagationStopped()}"
            # console.log e

        if @settings.hoverClass?
            @table.find('tbody').on 'mouseenter', 'tr', (e) =>
                $(e.currentTarget).addClass @settings.hoverClass
            @table.find('tbody').on 'mouseleave', 'tr', (e) =>
                $(e.currentTarget).removeClass @settings.hoverClass

    # Enables drag-n-drop for the table.
    #
    enable_drag_and_drop: =>
        @drag_and_drop = new SmartTreeTableDragAndDrop @

    # Disables drag-n-drop.
    #
    disable_drag_and_drop: ->
        @table_html_rows().draggable 'destroy'
        log "drag-n-drop disabled"


    # Returns last element of a branch starting at +id+.
    #
    get_branch_last_element: (id) ->
        children = @children_of id
        return id unless children? && children.length > 0
        @get_branch_last_element children[children.length-1].id # last of children

    # Moves tree branch/leaf to another node
    #
    move_tree_node: (from_id, to_id, insert_mode) ->
        source = @rows[from_id]
        target = @rows[to_id]

        # move around HTML elements
        if insert_mode == 'before'
            target.el.before( source.el )
        else # after -- moves node after last element of target branch
            new_target_id = @get_branch_last_element to_id
            log "move_tree_node: after, to_id=#{to_id} new_target_id=#{new_target_id}"
            target = @rows[new_target_id]
            target.el.after( source.el )
        @move_tree_node_children from_id

        # update data structures
        if insert_mode == 'into'
            new_parent_id = to_id
        else # before & after
            new_parent_id = @rows[to_id].parent_id
        console?.log "move_tree_node: new parent: #{new_parent_id}"
        if new_parent_id?
            source.parent_id = new_parent_id
            source.el.attr 'data-parent-id', new_parent_id
        else
            source.parent_id = null
            source.el.removeAttr 'data-parent-id'
        @update_table_rows()

        # finishing touches
        @expand to_id if insert_mode == 'into'


    # Moves tree node children in place.
    #
    move_tree_node_children: (parent_id, last_element = null) ->
        parent = @rows[parent_id]
        last_element = parent.el unless last_element?
        for row in @children_of parent_id
            last_element.after row.el
            last_element = row.el
            last_element = @move_tree_node_children row.id, last_element
        return last_element

$ ->
    log "initialized"
