class User

  # Creates a User from Admin::UserNewForm.
  #
  def self.create_from_admin_user_new_form( object )
    raise "Cannot create User from #{object.class}" unless object.is_a? Admin::UserNewForm

    tmp_password = self.generate_confirmation_token # generates random password
    self.new(
      full_name: object.full_name,
      roles: object.roles,
      emails: [{
        email: object.email,
        confirmed: false
      }],
      authentications: [{
        provider: :password,
        uid: object.email,
        email_id: object.email,
        password: tmp_password,
        password_confirmation: tmp_password
      }]
    )
  end

end # class User