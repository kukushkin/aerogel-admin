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
def link_to_modal( url, *args, &block )
  opts = (String === args.first) ? args[1] : args[0]
  opts = {
    href: url,
    'data-toggle' => 'modal',
    'data-target' => '#adminModal'
  }.deep_merge( opts || {} )
  if String === args.first
    args[1] = opts
  else
    args[0] = opts
  end
  tag :a, *args, &block
end

# Renders a link to open a modal window with remote content,
# if this operation is allowed.
# Renders a plain text otherwise.
#
def link_to_modal_if_can( url, text, opts = {} )
  if can? url
    link_to_modal url, text, opts
  else
    text
  end
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