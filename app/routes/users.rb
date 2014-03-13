namespace "/admin/users" do

  admin_menu "/admin/users/", icon: 'fa-users', label: :'aerogel.admin.panes.users', priority: 20


  before do
    layout "admin/modal" if request.xhr?
    # sleep 3 if request.xhr?
  end

  get "/" do
    pass
  end

  get "/new" do
    @admin_user_new_form = ::Admin::UserNewForm.new
    pass
  end

  post "/new" do
    @admin_user_new_form = ::Admin::UserNewForm.new( params[:admin_user_new_form] )
    pass unless @admin_user_new_form.valid?
    user = User.create_from_admin_user_new_form @admin_user_new_form
    unless user.save
      flash[:error] = t.aerogel.db.errors.failed_to_save name: User.model_name.human,
        errors: user.errors.full_messages.join(", ")
      pass
    end
    user.request_activation!
    email 'user/account_activation', user
    authentication = user.request_password_reset! @admin_user_new_form.email
    email 'user/password_reset', authentication
    redirect '/admin/users/', notice: t.aerogel.admin.actions.users.created( name: h( user.full_name ) )
  end

  get "/:id/edit" do
    @user = User.find( params[:id] ) or halt 404
    pass
  end

  post "/:id/edit" do
    @user = User.find( params[:id] ) or halt 404
    if @user.update_attributes params[:user].except( :emails, :authentications )
      redirect '/admin/users/', notice: t.aerogel.admin.actions.users.updated( name: h( @user.full_name ) )
    end
    flash.now[:error] = t.aerogel.db.errors.failed_to_save( name: h( @user.full_name ),
      errors: @user.errors.full_messages.join(", ")
    )
    pass
  end

  get "/:id/delete" do
    @user = User.find( params[:id] ) or halt 404
    pass
  end

  post "/:id/delete" do
    @user = User.find( params[:id] ) or halt 404
    if current_user == @user
      redirect '/admin/users/', error: t.aerogel.admin.actions.users.failed_to_delete_self
    else
      @user.destroy
      redirect '/admin/users/', notice: t.aerogel.admin.actions.users.deleted( name: h(@user.full_name)  )
    end
    pass
  end

  #
  # Common User controller routes
  #
  route :get, :post, ['/', '/:action', '/:id/:action'] do
    action = params[:action] || 'index'
    pass if params[:id] and [:roles, :access].include? params[:id].to_sym
    view "admin/users/#{action}"
  end

end