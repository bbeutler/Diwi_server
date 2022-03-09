class UserSerializer < ApplicationSerializer
  identifier :id

  view :show do
    fields :email, :profile_type
    association :profile, blueprint: ->(profile) { profile.serializer }
  end

  view :create do
    include_view :show
    field :token do |_user, options|
      options[:token]
    end
  end

  view :update do
    include_view :show
    exclude :token
  end
end
