module Api
  module V1
    class UsersController < ApiController
      USER_ROOT = 'user'.freeze
      load_and_authorize_resource except: :create
      skip_before_action :authenticate_user, only: :create

      def show
        resp = UserSerializer.render(@user, root: USER_ROOT, view: :show)
        # render json: UserSerializer.render(@user, root: USER_ROOT, view: :show),
        #        status: :ok
sql='SELECT  COUNT("looks".*) FROM "looks" WHERE "looks"."consumer_id" = '+ current_user.profile.id.to_s+ ' AND extract(month from "created_at") = extract(month from CURRENT_DATE)
'
 results = ActiveRecord::Base.connection.execute(sql)

 sql1='SELECT  COUNT("videos".*) FROM "videos" WHERE extract(month from "created_at") = extract(month from CURRENT_DATE)
 AND "videos"."look_id" IN (SELECT "looks".id FROM "looks" WHERE "looks"."consumer_id" ='+ current_user.profile.id.to_s+ ')'
 results1 = ActiveRecord::Base.connection.execute(sql1)

 sql2='SELECT "subscriptions".* from "subscriptions" WHERE (extract(month from "created_at") = extract(month from CURRENT_DATE) OR (extract(month from "updated_at") >= extract(month from CURRENT_DATE) - 1 AND extract(day from "updated_at") >= extract(day from CURRENT_DATE)) OR ("subscriptions".is_active = true)) AND "subscriptions"."consumer_id" = '+ current_user.profile.id.to_s 
results3 = ActiveRecord::Base.connection.execute(sql2)

        jsp = JSON.parse(resp)
        for i in results do
   
          jsp["user"]["looks_uploaded"] = i["count"]

      
        end
        for j in results1 do
   
          jsp["user"]["video_uploaded"] = j["count"]

      
        end

        for x in results3 do
          jsp["user"]["can_upload_unlimited"] = true
        end

        if jsp["user"]['can_upload_unlimited'] == nil
      jsp["user"]['can_upload_unlimited'] = false
    end
       # result = JSON.parse(results)
        # jsp = ["user"]["something"] = result["count"].to_s;
        # jsp["user"]["something"] = i["count"]Look.where(consumer_id: jsp["user"]["id"], created_at:  12);
        render json: jsp,status: :ok
      end

      def create
        registration = UserRegistrationForm.new(create_params)
        registration.save!
        @user = registration.user

        render_created_user
      end

      def update
        user_with_update_params = update_params.merge(user: @user)
        updated_user_form = UserUpdateForm.new(user_with_update_params).update!
        @updated_user = updated_user_form.user

        render json: UserSerializer.render(
          @updated_user,
          root: USER_ROOT,
          view: :update
        ), status: :ok
      end

      private

      def create_params
        params.permit(:email,
                      :password,
                      :password_confirmation,
                      :profile_type,
                      profile: %i[first_name
                                  last_name])
      end
      def update_params
        params.permit(:email,
                      :current_password,
                      :new_password,
                      :password_confirmation)
      end

      def render_created_user
        render json: UserSerializer.render(
          @user,
          root: USER_ROOT,
          view: :create,
          token: @user.generate_token
        ), status: :created
      end
    end
  end
end
