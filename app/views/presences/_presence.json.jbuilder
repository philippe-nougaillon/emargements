json.extract! presence, :id, :nom, :prénom, :heure, :signature, :created_at, :updated_at
json.url presence_url(presence, format: :json)
