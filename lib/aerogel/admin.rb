require 'aerogel/core'
require "aerogel/admin/version"

module Aerogel
  module Admin
    # Your code goes here...
  end

  # Finally, register module's root folder
  register_path File.join( File.dirname(__FILE__), '..', '..' )
end

