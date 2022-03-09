class TagCreateForm
  include ActiveModel::Model

  attr_accessor :title,
                :look_ids,
                :consumer,
                :tag

  def save!
    raise ActiveRecord::RecordInvalid, self unless valid?

    ActiveRecord::Base.transaction do
      create_tag!
      add_looks! if look_ids
    end
    self
  end

  private

  def create_tag!
    @tag = Tag.new(create_tag_params)
    raise CanCan::AccessDenied unless consumer.user.ability.can? :create, @tag

    @tag.save!
  end

  def create_tag_params
    {
      title: title,
      consumer: consumer
    }.tap { |hash| scrub_nils(hash) }
  end

  def scrub_nils(hash)
    hash.delete_if { |_key, value| value.nil? }
  end

  def add_looks!
    look_ids.each do |look_id|
      look = Look.find(look_id)
      LookTag.find_or_create_by!(tag: @tag, look: look)
    end
  end
end
