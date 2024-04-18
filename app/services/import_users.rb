class ImportUsers < ApplicationService
    attr_reader :emails, :organisation_id, :groupes
    private :emails, :organisation_id, :groupes

    def initialize(emails, organisation_id, groupes)
      @emails = emails
      @organisation_id = organisation_id
      @groupes = groupes
    end

    def call
      users_saved = 0
      @emails.each_with_index do |email, index|
        unless user = User.find_by(email: email, organisation_id: @organisation_id)
          user = User.create(email: email, password: SecureRandom.hex(5), organisation_id: @organisation_id)
          user.dispatch_email_to_nom_prénom
        end
        user.tag_list.add(@groupes.split(','))
        if user.save
          users_saved += 1
        end
      end

      return users_saved
    end

end