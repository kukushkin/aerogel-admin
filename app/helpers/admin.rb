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

# Renders a link to open a modal window with remote content.
#
def link_to_modal( url, text, opts = {} )
  opts = {
    href: url,
    'data-toggle' => 'modal',
    'data-target' => '#adminModal'
  }.deep_merge opts
  tag :a, text, opts
end

# Creates a <button ...>...</button> tag.
#
def button_to( url, text = url, opts = {} )
  opts = {
    class: "btn btn-default",
    href: url
  }.deep_merge opts
  tag :a, text, opts
end