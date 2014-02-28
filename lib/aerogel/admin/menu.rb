module Aerogel::Admin
  class Menu
    attr_accessor :items
    def initialize()
      @items = []
    end

    def self.instance
      @instance ||= self.new
    end

    class Item
      attr_accessor :url, :icon, :label, :priority
      def initialize( url, opts = {} )
        self.url = url
        self.icon = opts[:icon]
        self.label = opts[:label] || url
        self.priority = opts[:priority] || 50
      end

      def self.create( url, opts = {} )
        Menu.instance.items << self.new( url, opts )
      end
    end # class Item
  end # class Menu
end # module Aerogel::Admin