module Aerogel::Admin

  # TabsBuilder constructs and displays a tab navigation.
  # from passed object.
  #
  # Example:
  #   tabs do
  #     tab "/url/to/page1", label: "Page 1"
  #     tab "/url/to/page2", label: "Page 2"
  #   end
  #
  class TabsBuilder < Aerogel::Render::BlockHelper

    attr_accessor :options, :tabs, :style

    DEFAULT_OPTIONS = {
      style: 'standard'
    }

    def initialize( options = {}, &block )
      super( &block )
      self.options = DEFAULT_OPTIONS.deep_merge( options )
      self.style = self.options[:style]
      self.tabs = []
    end

    def tab( *args, &block )
      self.tabs << Tab.new( *args, &block )
      nil
    end

    def template( name )
      "admin/tabs_builder/#{style}/#{name}".to_sym
    end

    def wrap( content )
      erb template("tabs.html"), locals: { tabs: self }, layout: false
    end

  private

    class Tab

      attr_accessor :url, :label, :options, :block

      def initialize( url, options = {}, &block )
        self.url = url
        self.options = options
        self.label = self.options[:label] || self.url
        self.block = block
      end

    end # class Tab

  end # class TabsBuilder

end # module Aerogel::Admin


