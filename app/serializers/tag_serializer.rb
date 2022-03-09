class TagSerializer < ApplicationSerializer
  identifier :id

  view :index do
    fields :title, :created_at
  end

  view :show do
    include_view :index

    association :looks, blueprint: LookSerializer, view: :index
    association :look_tags, blueprint: LookTagSerializer
  end
end
