require 'aerogel/core'
require "aerogel/admin/version"
require "aerogel/admin/core"
require "aerogel/admin/menu"
require "aerogel/admin/table_builder"
require "aerogel/admin/tabs_builder"

module Aerogel

  # Finally, register module's root folder
  register_path File.join( File.dirname(__FILE__), '..', '..' )

  # configure module
  on_load do |app|
    app.register Aerogel::Admin
  end

end

