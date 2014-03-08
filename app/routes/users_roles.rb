namespace "/admin/users/roles" do

  get "/" do
    pass
  end

  get "/new" do
    @role = Role.new
    pass
  end

  post "/new" do
    @role = Role.new( params[:role] )
    pass unless @role.save
    redirect '/admin/users/roles/', notice: "Role '#{@role.name}' created"
  end

  get "/:id/edit" do
    @role = Role.find( params[:id] ) or halt 404
    pass
  end

  post "/:id/edit" do
    @role = Role.find( params[:id] ) or halt 404
    if @role.update_attributes params[:role]
      redirect '/admin/users/roles/', notice: "Role saved"
    end
    flash.now[:error] = "Failed to update role"
    pass
  end

  get "/:id/delete" do
    @role = Role.find( params[:id] ) or halt 404
    pass
  end

  post "/:id/delete" do
    @role = Role.find( params[:id] ) or halt 404
    @role.destroy
    redirect '/admin/users/roles/', notice: "Role '#{@role.name}' deleted"
    pass
  end
  #
  # Common User/Roles controller routes
  #
  route :get, :post, ['/', '/:action', '/:id/:action'] do
    action = params[:action] || 'index'
    view "admin/users/roles/#{action}"
  end

end