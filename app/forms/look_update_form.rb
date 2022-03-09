class LookUpdateForm
  include ActiveModel::Model

  attr_accessor :title,
                :note,
                :location,
                :dates_worn,
                :tag_ids,
                :consumer,
                :photos,
                :videos,
                :look_tag_ids_to_be_deleted,
                :dates_worn_to_be_deleted,
                :photo_ids_to_be_deleted,
                :video_ids_to_be_deleted,
                :look

  def update!
    raise ActiveRecord::RecordInvalid, self unless valid?

    ActiveRecord::Base.transaction do
      update_look!
      add_tags! if tag_ids
      add_photos! if photos
      add_videos! if videos
      delete_look_tags if look_tag_ids_to_be_deleted
      delete_photos if photo_ids_to_be_deleted
      delete_videos if video_ids_to_be_deleted
    end
    self
  end

  private

  def update_look!
    @look = look
    @look.title = title if title
    @look.note = note if note
    @look.location = location if location

    if dates_worn.present? && dates_worn.count.positive?
      update_dates_worn
      @look.dates_worn_will_change!
    end

    if dates_worn_to_be_deleted.present? && dates_worn_to_be_deleted.count.positive?
      remove_dates_worn
      @look.dates_worn_will_change!
    end

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

  def update_dates_worn
    dates_worn.each do |date_worn|
      date = begin
               Date.parse(date_worn)
             rescue StandardError
               false
             end
      raise ActiveRecord::RecordInvalid, self unless date

      if date && !@look.dates_worn.nil? && !@look.dates_worn.include?(date)
        @look.dates_worn << date
      end
    end
  end

  def remove_dates_worn
    dates_worn_to_be_deleted.each do |date_worn|
      date = begin
               Date.parse(date_worn)
             rescue StandardError
               false
             end
      @look.dates_worn.delete(date) if date && @look.dates_worn.include?(date)
    end
  end

  def add_tags!
    tag_ids.each do |tag_id|
      tag = Tag.find(tag_id)
      LookTag.find_or_create_by!(look: @look, tag: tag)
    end
  end

  def add_photos!
    photos.each do |photo_image|
      Photo.create!(look: @look, image: photo_image)
    end
  end
 def add_videos!
    videos.each do |video_video|
      Video.create!(look: @look, video: video_video)
    end
  end
  def delete_look_tags
    look_tag_ids_to_be_deleted.each do |id|
      @look_tag = LookTag.find(id)
      @look_tag.destroy!
    end
  end

  def delete_photos
    final_photo_count = @look.photos.count - photo_ids_to_be_deleted.count

    # Return an error if no photos are left on a look
    unless final_photo_count.positive?
      errors.add(:photo, 'at least one photo is required')
      raise ActiveRecord::RecordInvalid, self
    end

    photo_ids_to_be_deleted.each do |id|
      @photo = Photo.find(id)
      @photo.destroy!
    end
  end
  def delete_videos
    final_video_count = @look.videos.count - video_ids_to_be_deleted.count
    video_ids_to_be_deleted.each do |id|
      @video = Video.find(id)
      @video.destroy!
    end
  end
end
