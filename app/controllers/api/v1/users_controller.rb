class Api::V1:usersController < ApplicationController

  def facebook
    if params[:facebook_access_token]
      graph = Koala::Facebook::Api.new(params[:facebook_access_token])
      user_data = graph.get_object("me?fields=name,email,id,picture")
      user = User.find_by(email:user_data["email"])

      if user
        user.generate_new_auth_token
        json_response "User Information", true, { user: user }, :ok
        # User.create(user)
      else
        user = User.new(
                      email: user_data["email"],
                      uid: user_data["id"],
                      provider: "facebook",
                      image: user_data["picture"]["data"]["url"],
                      password: Devise.friendly_token([0,20])
              )
        user.authentication_token = user.generate_unique_secure_token
        if user.save
           json_response "Login Succssfully",true, { user: user }, :ok
         else
           json_response user.errors, false, {}, :unprocessable_entity
        end
      end
    else
      json_response "Missing Facebook Auth Token",false, {}, :unprocessable_entity
    end
  end
end
