#
# Admin helpers
#

# Defines a menu item
#
def admin_menu( url, opts = {} )
  Aerogel::Admin::Menu::Item.create url, opts
end

# Returns list of menu items ordered by priority
#
def admin_menu_items
  Aerogel::Admin::Menu.instance.items.sort_by( &:priority )
end