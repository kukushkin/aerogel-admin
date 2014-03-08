namespace "/admin/users/access" do


  get "/" do
    pass
  end

  get "/new" do
    @access = Access.new
    pass
  end

  post "/new" do
    @access = Access.new( params[:access] )
    pass unless @access.save
    redirect '/admin/users/access/', notice: "Access rule for '#{@access.path}' created"
  end

  get "/:id/edit" do
    @access = Access.find( params[:id] ) or halt 404
    pass
  end

  post "/:id/edit" do
    @access = Access.find( params[:id] ) or halt 404
    if @access.update_attributes params[:access].except( :path_matcher )
      redirect '/admin/users/access/', notice: "Access rule saved"
    end
    flash.now[:error] = "Failed to update access rule"
    pass
  end

  get "/:id/delete" do
    @access = Access.find( params[:id] ) or halt 404
    pass
  end

  post "/:id/delete" do
    @access = Access.find( params[:id] ) or halt 404
    @access.destroy
    redirect '/admin/users/access/', notice: "Access rule for '#{@access.path}' deleted"
    pass
  end

  #
  # Common User/Access controller routes
  #
  route :get, :post, ['/', '/:action', '/:id/:action'] do
    action = params[:action] || 'index'
    view "admin/users/access/#{action}"
  end

end
