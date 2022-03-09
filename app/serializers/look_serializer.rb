class LookSerializer < ApplicationSerializer
  identifier :id

  view :index do
    fields :title, :created_at, :dates_worn

    field :image do |look|
      look.photos&.last&.image&.url
    end

    field :thumbnail do |look|
      if !look.photos&.last&.image&.thumb&.url
        look.photos&.last&.image&.url
      else
        look.photos&.last&.image&.thumb&.url
      end
    end
  end

  view :show do
    include_view :index
    fields :note, :location
    association :tags, blueprint: TagSerializer, view: :index
    association :look_tags, blueprint: LookTagSerializer
    association :photos, blueprint: PhotoSerializer
  end

  view :result do
    include_view :index
    association :tags, blueprint: TagSerializer, view: :index
    association :look_tags, blueprint: LookTagSerializer
  end

  

end
