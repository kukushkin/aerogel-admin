# Renders UserEmail.confirmed attribute as icon
#
def user_email_confirmed_as_icon( email )
  email.confirmed ?
    icon( "glyphicon-ok-sign", title: t.aerogel.admin.decorators.confirmed, style: "color: green" ) :
    icon( "glyphicon-question-sign", title: t.aerogel.admin.decorators.not_confirmed )
end

# Renders UserEmail.confirmed attribute as label
#
def user_email_confirmed_as_label( email )
  email.confirmed ?
      "<span class='label label-success'>#{t.aerogel.admin.decorators.confirmed}</span>" :
      "<span class='label label-default'>#{t.aerogel.admin.decorators.not_confirmed}</span>"
end

# Renders Authentication provier as icon.
#
def auth_provider_as_icon( provider_key )
  provider = Aerogel::Auth.providers[provider_key]
  icon provider[:icon], title: provider[:name]
end

# Renders Authentication provier as icon.
#
def auth_provider_as_text( provider_key )
  provider = Aerogel::Auth.providers[provider_key]
  provider[:name]
end