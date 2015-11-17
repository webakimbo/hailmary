ActiveAdmin.register Group do

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

  permit_params :name, :tagline, :avatar, :administrator_user_id, :active

  form do |f|
    inputs "User Details" do
      input :name
      input :tagline
      input :administrator_user_id, :as => :select, :collection => f.object.users, :include_blank => false
      input :avatar, :as => :file
      input :active, :as => :boolean
    end

    actions

  end

end
