namespace "/admin/users" do

  admin_menu "/admin/users/", icon: 'fa-users', label: 'Users', priority: 20


  before do
    layout "admin/modal" if request.xhr?
  end

  get "/" do
    pass
  end

  get "/:id/edit" do
    @user = User.find params[:id]
    view "admin/users/user_edit"
  end

  post "/:id/edit" do
    @user = User.find params[:id]
    if @user.update_attributes params[:user].except( :emails, :authentications )
      flash[:notice] = "User details saved"
      redirect '/admin/users/'
    end
    flash.now[:error] = "Failed to update user profile"
    view "admin/users/user_edit"
  end

  #
  # Common User controller routes
  #
  route :get, :post, ['/', '/:action'] do
    action = params[:action] || 'index'
    view "admin/users/#{action}"
  end

end