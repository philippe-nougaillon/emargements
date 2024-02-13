json.extract! user, :id, :nom, :prénom, :email, :adresse, :created_at, :updated_at
json.url user_url(user, format: :json)
