ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  permit_params :first_name, :last_name, :handle, :display_name_as, :location, :avatar, :email, :password, :show_location, :show_email, :active

  form do |f|
    inputs "User Details" do
      input :first_name
      input :last_name
      input :handle
      input :display_name_as, :as => :select, :collection => Constants::DISPLAY_NAME_OPTS.invert, :include_blank => false
      input :location
      input :avatar, :as => :file
      input :email
      input :password
      input :password_confirmation
      input :show_location, :as => :boolean
      input :show_email, :as => :boolean
      input :active, :as => :boolean
    end

    actions

  end

end
