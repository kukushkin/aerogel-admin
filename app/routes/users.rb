namespace "/admin/users" do

  admin_menu "/admin/users/", icon: 'fa-users', label: 'Users', priority: 20

  get "/" do
    pass
  end

  #
  # Common User controller routes
  #
  route :get, :post, ['/', '/:action'] do
    action = params[:action] || 'index'
    view "admin/users/#{action}"
  end

end