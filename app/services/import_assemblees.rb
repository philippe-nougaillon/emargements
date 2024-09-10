class ImportAssemblees < ApplicationService
    attr_reader :assemblees_infos, :user, :groupes
    private :assemblees_infos, :user, :groupes

    def initialize(assemblees_infos, user, groupes)
      @assemblees_infos = assemblees_infos
      @user = user
      @groupes = groupes
    end

    def call
      assemblees_saved = 0
      @assemblees_infos.each_with_index do |assemblee_infos, index|
        begin
          nom, date, heure, durée = assemblee_infos.split(/[;,]/)
          début = date.to_date + Time.parse(heure).seconds_since_midnight.second
          unless assemblee = Assemblee.find_by(nom: nom, user_id: @user.id, organisation_id: @user.organisation_id)
            assemblee = Assemblee.create(nom: nom, début: début, durée: durée, user_id: @user.id, organisation_id: @user.organisation_id)
          else
            assemblee.début = début if assemblee.début != début
            assemblee.durée = durée if assemblee.durée != durée
          end

          assemblee.tag_list.add(@groupes.split(',')) if @groupes
          if assemblee.save
            assemblees_saved += 1
          end
        rescue
        end
      end

      return assemblees_saved
    end

end