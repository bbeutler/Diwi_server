class LookCreateForm
  include ActiveModel::Model

  attr_accessor :title,
                :note,
                :location,
                :dates_worn,
                :tag_ids,
                :consumer,
                :photos,
                :look
  def save!
    raise ActiveRecord::RecordInvalid, self unless valid?

    ActiveRecord::Base.transaction do
      create_look!
      add_tags! if tag_ids
      add_photos!
    end
    self
  end

  private

  def create_look!
    @look = Look.new(title: title,
                     note: note,
                     location: location,
                     consumer: consumer)

    @look.dates_worn = dates_worn if dates_worn.present?

    raise CanCan::AccessDenied unless consumer.user.ability.can? :create, @look
    raise ActiveRecord::RecordInvalid, self unless dates_worn_valid

    @look.save!
  end

  def dates_worn_valid
    if dates_worn.present?
      @look.dates_worn.all? { |d| !d.nil? }
    else
      true
    end
  end

  def add_tags!
    tag_ids.each do |tag_id|
      tag = Tag.find(tag_id)
      LookTag.find_or_create_by!(look: @look, tag: tag)
    end
  end

  def add_photos!
    # Return an error if at least one photo is not provided
    unless photos && photos.count.positive?
      errors.add(:photo, 'at least one photo is required')
      raise ActiveRecord::RecordInvalid, self
    end

    photos.each do |photo_image|
      Photo.create!(look: @look, image: photo_image)
    end
  end
end
