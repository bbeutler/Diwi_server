class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    consumer_abilities(user) if user.consumer?
  end

  private

  def consumer_abilities(user)
    can :manage, Consumer, id: user.profile_id
    can %i[create update], Device, consumer_id: user.profile_id
    can :manage, Look, consumer_id: user.profile_id
    can :manage, LookTag, look_id: look_ids(user.profile)
    can :manage, Photo, look_id: look_ids(user.profile)
    can :manage, Tag, consumer_id: user.profile_id
    can %i[create update show], Subscription, consumer_id: user.profile_id
    can %i[read create], TermsAcceptance, consumer_id: user.profile_id
    can %i[read create update], User, id: user.id
  end

  def look_ids(consumer)
    consumer.looks.map(&:id)
  end
end
