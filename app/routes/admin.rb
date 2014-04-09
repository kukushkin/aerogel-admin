namespace "/admin" do

  # admin_menu "/admin/lorem", label: 'Lorem'

  before do
    if request.xhr?
      layout "admin/modal"
    else
      layout "admin"
    end

    on_access_denied do |path|
      redirect "/user/login?on_success=#{path}" unless current_user?
      redirect "/admin/" if can? "/admin/"
    end

  end

  get "/" do
    flash.now[:notice] = "Welcome, admin!"
    pass
  end

  get "/lorem" do
    view "lorem"
  end

  #
  # Common User controller routes
  #
  route :get, :post, ['/', '/:action'] do
    action = params[:action] || 'index'
    view "admin/#{action}"
  end


end