module Admin
  class UserNewForm
    include Model::NonPersistent

    field :full_name, type: String
    field :email, type: String
    field :roles, type: Array, default: [:user]

    validates_presence_of :full_name, :email, :roles
    validates_format_of :email, with: /@/, message: :invalid_format

    validate do |record|
      # validate email
      if User.elem_match( :authentications => { :provider => :password, :uid => record.email } ).count > 0
        record.errors.add :email, :taken
      elsif User.elem_match( :emails => { :email => record.email } ).count > 0
        record.errors.add :email, :taken
      end
      # validate roles
      if record.roles_changed?
        unless Role.slugs.contains? record.roles
          record.errors.add :roles, :invalid_roles
        end
      end

    end

    # accessors:
    def roles=( value )
      if value.is_a? Array
        self[:roles] = value.map(&:to_sym)
      elsif value.is_a? String
        self[:roles] = value.split(",").map{|v| v.strip.to_sym}
      else
        raise ArgumentError.new "Invalid value of class #{value.class} passed to roles= setter"
      end
    end

  end # class UserNewForm
end # module Admin
