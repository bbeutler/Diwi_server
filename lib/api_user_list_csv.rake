# This rake task must be called with the following command:
# rake api_user_list_csv:run
#
# api_user_data_DATETIME.csv will be saved in public/user_data folder
# See README for instructions on how to run rake task and obtain this file
namespace :api_user_list_csv do
  desc 'Creates a list of the current user data and saves it to a csv'
  task run: :environment do
    puts "Creating CSV of #{User.count} users..."
    csv_file_path = Rails.root.join(
      'public',
      'user_data',
      "api_user_data_#{DateTime.now}.csv"
    )

    CSV.open(csv_file_path, 'w') do |csv|
      csv << csv_headers

      User.all.each do |user|
        csv << save_user_to_csv(user)
      end
    end

    puts 'Done!'
  end

  def csv_headers
    %i[
      id
      first_name
      last_name
      email
      profile_type
      profile_id
      created_at
      updated_at
    ]
  end

  def save_user_to_csv(user)
    [
      user.id.to_s,
      user.profile.first_name,
      user.profile.last_name,
      user.email,
      user.profile_type,
      user.profile_id.to_s,
      user.created_at.to_date.to_s,
      user.updated_at.to_date.to_s
    ]
  end
end
