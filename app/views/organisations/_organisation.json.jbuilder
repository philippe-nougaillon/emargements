json.extract! organisation, :id, :nom, :adresse, :logo, :created_at, :updated_at
json.url organisation_url(organisation, format: :json)
json.logo url_for(organisation.logo)
