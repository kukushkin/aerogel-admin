namespace "/admin/users/access" do

  #
  # Common User/Access controller routes
  #
  route :get, :post, ['/', '/:action'] do
    action = params[:action] || 'index'
    view "admin/users/access/#{action}"
  end

end