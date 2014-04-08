
Function::property = (name) ->
    Object.defineProperty @prototype, name,
        get: -> @get_property name
        set: (v) -> @set_property name, v

# An object representing tree table row.
#
#
class @SmartListTableRow

    constructor: (@table, @el) ->
        @id = @el.attr 'data-id'
        @contents = @active_column().html()
        @attributes = {}
        for attr in @el.get(0).attributes
            @attributes[attr.name] = attr.value
        @_properties = {}


    active_column: ->
        @el.find(@table.settings.active_column_selector).first()

    render: ->
        @el.removeClass "#{@table.settings.selectedClass}"
        @el.addClass @table.settings.selectedClass if @get_property 'selected'
        # @active_column().html( "#{@_prefix()}#{@contents}")

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

    @property 'selected'
    # @property 'other_prop1'


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

