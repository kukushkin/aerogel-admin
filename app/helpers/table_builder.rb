
# Table builder.
#
#
def table( object, options = {}, &block )
  Aerogel::Admin::TableBuilder.new( object, options, &block ).render
end

