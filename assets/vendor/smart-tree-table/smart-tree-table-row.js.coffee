
Function::property = (name) ->
    Object.defineProperty @prototype, name,
        get: -> @get_property name
        set: (v) -> @set_property name, v

# An object representing tree table row.
#
#
class @SmartTreeTableRow

    constructor: (@table, @el) ->
        @id = @el.attr 'data-id'
        @parent_id = @el.attr 'data-parent-id'
        @parent_id = null if @parent_id == ''
        @contents = @active_column().html()
        @attributes = {}
        for attr in @el.get(0).attributes
            @attributes[attr.name] = attr.value
        @_properties = {}


    active_column: ->
        @el.find(@table.settings.active_column_selector).first()

    render: ->
        @el.removeClass "#{@table.settings.selectedClass} branch leaf expanded collapsed"
        @el.addClass @table.settings.selectedClass if @get_property 'selected'
        @el.addClass if @get_property('branch') then 'branch' else 'leaf'
        @el.addClass if @get_property('expanded') then 'expanded' else 'collapsed'
        @active_column().html( "#{@_prefix()}#{@contents}")

    show: ->
        @el.show()

    hide: ->
        @el.hide()

    get_property: (name) ->
        @_properties[name]
    set_property: (name, v) ->
        @_properties[name] = v
        @render()
        v

    @property 'level'
    @property 'expanded'
    @property 'branch'
    @property 'selected'


    _indenter: (level) ->
        px = level * @table.settings.indent
        "<span class='indenter' style='padding-left:#{px}px'></span>"

    _prefix: ->
        p_indent = @_indenter @get_property 'level'
        p_prefix = ''
        s = {}
        if @get_property 'branch'
            s = @table.settings.prefix.branch
        else
            s = @table.settings.prefix.leaf
        if @get_property 'expanded'
            p_prefix = s.expanded
        else
            p_prefix = s.collapsed
        "#{p_indent}#{p_prefix}"

