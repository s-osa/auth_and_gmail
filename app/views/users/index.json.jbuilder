json.array!(@users) do |user|
  json.extract! user, :id, :uuid, :email, :name, :access_token, :refresh_token
  json.url user_url(user, format: :json)
end
