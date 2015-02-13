require "google/api_client"

class DraftsController < ApplicationController
  # POST /drafts
  def create
    message = Mail.new
    message.to      = "example@example.com"
    message.subject = "こんにちは、Gmail! "
    message.body    = "Create draft via Gmail API. テストですよ、テスト。"

    client = Google::APIClient.new(application_name: "auth-and-gmail")
    client.authorization.access_token = current_user.access_token
    gmail = client.discovered_api("gmail")

    res = client.execute(
      api_method: gmail.users.drafts.create,
      parameters: {"userId" => "me"},
      body_object: {
        "message" => {"raw" => Base64.urlsafe_encode64(message.to_s)}
      }
    )

    raise RuntimeError unless res.status == 200

    json = JSON.parse(res.body)
    redirect_to root_path, notice: "Successfully created."
  rescue
    redirect_to root_path, notice: $!
  end
end
