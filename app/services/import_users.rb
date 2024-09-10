class ImportUsers < ApplicationService
    attr_reader :users_infos, :organisation_id, :groupes
    private :users_infos, :organisation_id, :groupes

    def initialize(users_infos, organisation_id, groupes)
      @users_infos = users_infos
      @organisation_id = organisation_id
      @groupes = groupes
    end

    def call
      users_saved = 0
      @users_infos.each_with_index do |user_infos, index|
        begin
          email, nom, prénom = user_infos.tr(' ','').split(/[;,]/)
          unless user = User.find_by(email: email, organisation_id: @organisation_id)
            user = User.create(email: email, password: SecureRandom.hex(5), organisation_id: @organisation_id)
            if nom || prénom
              user.nom, user.prénom = nom, prénom
            else
              user.dispatch_email_to_nom_prénom
            end
            user.skip_confirmation!
          else
            user.nom = nom if user.nom != nom
            user.prénom = prénom if user.prénom != prénom
          end

          user.tag_list.add(@groupes.split(',')) if @groupes
          if user.save
            users_saved += 1
          end
        rescue
        end
      end

      return users_saved
    end

end