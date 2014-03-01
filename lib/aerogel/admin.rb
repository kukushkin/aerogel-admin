require 'aerogel/core'
require "aerogel/admin/version"
require "aerogel/admin/menu"
require "aerogel/admin/table_builder"
require "aerogel/admin/tabs_builder"

module Aerogel
  module Admin
    # Your code goes here...
  end

  # Finally, register module's root folder
  register_path File.join( File.dirname(__FILE__), '..', '..' )
end

