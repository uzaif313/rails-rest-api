module Authenticate

  def current_user
    auth_token = request.headers["AUTH-TOKEN"]
    return unless auth_token
    @current_user = User.find_by authentication_token: auth_token
  end


  def authenticate_with_token!
    return if current_user
    json_response "Unauthorized User", false, {}, :unauthorized
  end

  def authorized? user
    current_user.id == user.id
  end
end
