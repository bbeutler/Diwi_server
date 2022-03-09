class TagUpdateForm
  include ActiveModel::Model

  attr_accessor :title,
                :look_ids,
                :consumer,
                :tag_look_ids_to_be_deleted,
                :tag

  def update!
    raise ActiveRecord::RecordInvalid, self unless valid?

    ActiveRecord::Base.transaction do
      update_tag!
      add_looks! if look_ids
      delete_tag_looks if tag_look_ids_to_be_deleted
    end
    self
  end

  private

  def update_tag!
    @tag = tag
    @tag.update!(title: title)
  end

  def add_looks!
    look_ids.each do |look_id|
      look = Look.find(look_id)
      LookTag.find_or_create_by!(tag: @tag, look: look)
    end
  end

  def delete_tag_looks
    tag_look_ids_to_be_deleted.each do |id|
      tag_look = LookTag.find(id)
      tag_look.destroy!
    end
  end
end
