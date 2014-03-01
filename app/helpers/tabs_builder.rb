
# Tabs builder.
#
#
def tabs( options = {}, &block )
  Aerogel::Admin::TabsBuilder.new( options, &block ).render
end
