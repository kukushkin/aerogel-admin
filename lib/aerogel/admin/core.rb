module Aerogel::Admin

  def self.registered(app)
    setup_reloader(app) if Aerogel.config.aerogel.reloader?

    # module initialization
  end

  def self.setup_reloader(app)
    app.use Aerogel::Reloader, :routes, before: true do
      Aerogel::Admin::Menu.reset!
    end
  end
end # module Aerogel::Admin