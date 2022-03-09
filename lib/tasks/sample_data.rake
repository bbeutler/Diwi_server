require 'faker'

# Creates sample data for development
namespace :sample do
  desc 'Creates all sample data'
  task all: %i[consumers terms_acceptances tags looks]

  desc 'Creates users with consumer profiles'
  task consumers: :environment do
    # Don't run in production
    return if ENV['NO_SAMPLE_DATA']

    Chewy.strategy(:atomic) do
      puts 'Creating consumers profiles...'
      5.times do
        Consumer.create!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
        )
      end

      puts 'Creating users...'
      profiles = Consumer.all
      profiles.each do |prof|
        User.create!(
          email: Faker::Internet.email,
          password: 'password',
          password_confirmation: 'password',
          profile_type: 'Consumer',
          profile_id: prof.id
        )
      end
    end

    puts "Done! #{User.count} Consumers created!"
  end

  desc 'Creates terms acceptances'
  task terms_acceptances: :environment do
    # Don't run in production
    return if ENV['NO_SAMPLE_DATA']

    puts 'Creating terms acceptances...'
    consumers = Consumer.all
    Chewy.strategy(:atomic) do
      consumers.each do |consumer|
        TermsAcceptance.create!(
          consumer_id: consumer.id,
          accepted_at: DateTime.now - 30.days,
          remote_ip: Faker::Internet.ip_v4_address
        )
      end
    end

    puts 'Done.'
  end

  desc 'Creates Tags'
  task tags: :environment do
    # Don't run in production
    return if ENV['NO_SAMPLE_DATA']

    Chewy.strategy(:atomic) do
      puts 'Creating Consumers\' Friends...'
      Consumer.all.each do |c|
        5.times do
          Tag.create!(title: Faker::Name.name, consumer: c)
        end
      end
    end

    puts "Done! #{Tag.count} Tags created!"
  end

  desc 'Create Looks with Tags....'
  task looks: :environment do
    return if ENV['NO_SAMPLE_DATA']
    Chewy.strategy(:atomic) do

      Consumer.all.each do |c|
        @look = Look.create!(title: Faker::Lorem.unique.words(6),
        note: Faker::Lorem.sentences(3),
        location: Faker::Address.city,
        dates_worn: [Faker::Date.birthday(3)],
        consumer: c)

        File.open('tmp/uploads/photo/image/1/pink-dress.png') do |f|
          Photo.create!(image: f, look: @look)
        end

          LookTag.find_or_create_by!(look: @look, tag: c.tags.sample)
      end
      puts "Done! #{Look.count} Looks created!"
    end
  end


  desc 'Destroys all sample data'
    task clean: :environment do
      # Don't run in production
      return if ENV['NO_SAMPLE_DATA']

      puts 'Removing all sample data...'
      Chewy.strategy(:atomic) do
        User.destroy_all
        Consumer.destroy_all
        Look.destroy_all
        Tag.destroy_all
        LookTag.destroy_all
      end

      puts 'Done!'
  end
end