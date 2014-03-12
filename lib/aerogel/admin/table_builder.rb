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
      self.columns << Column.new( self, *args, &block )
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

      attr_accessor :table, :field, :label, :options, :block

      def initialize( table, field, options = {}, &block )
        self.table = table
        self.field = field
        self.options = options
        self.block = block
        self.label = self.options[:label] || self.field.to_sym
      end

      def human_label
        if label.is_a? Symbol
          if table.object.respond_to? :human_attribute_name
            table.object.human_attribute_name label, default: label
          else
            I18n.t label
          end
        elsif label.is_a? String
          label
        else
          label.to_s.humanize
        end
      end

    end # class Column

  end # class TableBuilder

end # module Aerogel::Admin


