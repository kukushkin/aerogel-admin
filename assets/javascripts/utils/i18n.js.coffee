#
log = (msg) ->
    console?.log "** admin/i18n: #{msg}"


class I18nProcessor
    # @default_locale: 'en'

    constructor: ( @default_locale = 'en', @options = {} ) ->
        # ...
        log "locale processor initialized: #{@default_locale}"
        @set @default_locale

    # Sets new locale
    #
    set: (locale) ->
        @current_locale = locale
        log "locale set to: #{locale}"

    # Returns current locale
    #
    locale: ->
        @current_locale

@I18n = new I18nProcessor


