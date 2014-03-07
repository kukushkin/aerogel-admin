namespace "/admin/users/roles" do

  #
  # Common User/Roles controller routes
  #
  route :get, :post, ['/', '/:action'] do
    action = params[:action] || 'index'
    view "admin/users/roles/#{action}"
  end

end