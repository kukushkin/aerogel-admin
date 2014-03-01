module Aerogel::Admin

  # TableBuilder constructs and displays a table populated with data obtained
  # from passed object.
  #
  # Example:
  #   table User.all do
  #     column :full_name
  #     column :roles
  #   end
  #
  class TableBuilder < Aerogel::Render::BlockHelper

    attr_accessor :object, :options, :columns, :style

    DEFAULT_OPTIONS = {
      class: 'table-striped',
      style: 'standard'
    }

    def initialize( object, options = {}, &block )
      super( &block )
      self.object = object
      self.options = DEFAULT_OPTIONS.deep_merge( options )
      self.style = self.options[:style]
      self.columns = []
    end

    def column( *args, &block )
      self.columns << Column.new( *args, &block )
      nil
    end

    def template( name )
      "admin/table_builder/#{style}/#{name}".to_sym
    end

    def wrap( content )
      erb template("table.html"), locals: { table: self }, layout: false
    end

  private

    class Column

      attr_accessor :field, :label, :options, :block

      def initialize( field, options = {}, &block )
        self.field = field
        self.options = options
        self.block = block
        self.label = self.options[:label] || self.field.to_s.humanize
      end

    end # class Column

  end # class TableBuilder

end # module Aerogel::Admin


