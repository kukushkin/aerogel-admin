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
    redirect '/admin/users/roles/', notice: t.aerogel.admin.actions.users_roles.created( name: @role.name )
  end

  get "/:id/edit" do
    @role = Role.find( params[:id] ) or halt 404
    pass
  end

  post "/:id/edit" do
    @role = Role.find( params[:id] ) or halt 404
    if @role.update_attributes params[:role]
      redirect '/admin/users/roles/', notice: t.aerogel.admin.actions.users_roles.updated( name: @role.name )
    end
    flash.now[:error] = t.aerogel.db.errors.failed_to_save name: Role.model_name.human,
      errors: @role.errors.full_messages.join(", ")
    pass
  end

  get "/:id/delete" do
    @role = Role.find( params[:id] ) or halt 404
    pass
  end

  post "/:id/delete" do
    @role = Role.find( params[:id] ) or halt 404
    @role.destroy
    redirect '/admin/users/roles/', notice: t.aerogel.admin.actions.users_roles.deleted( name: @role.name )
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