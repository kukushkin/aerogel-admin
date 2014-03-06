namespace "/admin/users" do

  admin_menu "/admin/users/", icon: 'fa-users', label: 'Users', priority: 20


  before do
    layout "admin/modal" if request.xhr?
  end

  get "/" do
    pass
  end

  get "/:id/edit" do
    @user = User.find( params[:id] ) or halt 404
    view "admin/users/user_edit"
  end

  post "/:id/edit" do
    @user = User.find( params[:id] ) or halt 404
    if @user.update_attributes params[:user].except( :emails, :authentications )
      redirect '/admin/users/', notice: "User details saved"
    end
    flash.now[:error] = "Failed to update user profile"
    view "admin/users/user_edit"
  end

  get "/:id/delete" do
    @user = User.find( params[:id] ) or halt 404
    view "admin/users/user_delete"
  end

  post "/:id/delete" do
    @user = User.find( params[:id] ) or halt 404
    if current_user == @user
      redirect '/admin/users/', error: "No, you cannot delete self"
    else
      @user.destroy
      redirect '/admin/users/', notice: "User '#{h @user.full_name}' deleted"
    end
    view "admin/users/user_delete"
  end

  #
  # Common User controller routes
  #
  route :get, :post, ['/', '/:action'] do
    action = params[:action] || 'index'
    view "admin/users/#{action}"
  end

end