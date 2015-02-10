require "google/api_client"
require "net/http"
require "net/https"

class SessionsController < ApplicationController
  skip_before_action :user_authenticate!, only: [:new, :oauth2]

  HOST = Rails.env.production? ? "https://auth-and-gmail.herokuapp.com" : "http://localhost:3000"
  CLIENT_ID     = ENV['AUTH_AND_GMAIL_ID']
  CLIENT_SECRET = ENV['AUTH_AND_GMAIL_SECRET']

  def new
    return redirect_to root_path if user_signed_in?

    anti_forgery_token = SecureRandom.hex(16)
    session["oauth2_csrf"] = anti_forgery_token

    code_query = {
      response_type: "code",
      client_id: CLIENT_ID,
      access_type: "offline",
      approval_prompt: "force",
      redirect_uri: "#{HOST}/oauth2",
      scope: [
        "https://www.googleapis.com/auth/plus.me",
        "https://www.googleapis.com/auth/userinfo.email"
      ].join(" "),
      state: anti_forgery_token
    }.to_param

    @oauth2_url = "https://accounts.google.com/o/oauth2/auth?#{code_query}"
  end

  def oauth2
    return redirect_to root_path if user_signed_in?

    return redirect_to login_path(auth: "failed") if session["oauth2_csrf"].nil?
    return redirect_to login_path(auth: "failed") if session["oauth2_csrf"] != params["state"]

    code = params["code"]
    return redirect_to login_path(auth: "failed") if code.nil?

    tokens = exchange_code(code)
    access_token, refresh_token = tokens["access_token"], tokens["refresh_token"]

    tokeninfo = fetch_tokeninfo(access_token)
    email = tokeninfo["email"]

    return redirect_to login_path(auth: "failed") if email !~ User::EMAIL_REGEXP

    user =  User.exists?(email: email) ? User.find_by(email: email) : User.create!( email: email, name: email.sub(/@.+\z/, ""), access_token: access_token, refresh_token: refresh_token)

    login(user)
    redirect_to login_path(auth: "success")
  rescue
    puts $@, $!
    return redirect_to login_path(auth: "failed")
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def login(user)
    session["user_uuid"] = user.uuid
  end

  def logout
    session.delete("user_uuid")
  end

  def exchange_code(code)
    token_query = {
      code: code,
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      redirect_uri: "#{HOST}/oauth2",
      grant_type: "authorization_code"
    }.to_param

    res = https_client.post("/oauth2/v3/token", token_query)
    JSON.parse(res.body)
  end

  def fetch_tokeninfo(access_token)
    res = https_client.get("/oauth2/v1/tokeninfo?access_token=#{access_token}")
    JSON.parse(res.body)
  end

  def fetch_profile(access_token)
    client = Google::APIClient.new(application_name: "auth-and-gmail")
    client.authorization.access_token = access_token
    plus = client.discovered_api("plus")
    res = client.execute(
      api_method: plus.people.get,
      parameters: {"userId" => "me"}
    )
    JSON.parse(res.body)
  end

  def https_client
    https = Net::HTTP.new("www.googleapis.com", 443)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    https
  end
end
