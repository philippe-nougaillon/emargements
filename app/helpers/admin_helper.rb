module AdminHelper
  def prettify(audit)

    pretty_changes = []

    audit.audited_changes.each do |c|
      key = c.first.humanize
      case key
      when 'Salle'
        if salle = convertir_id_salles(audit)
          pretty_changes << salle
        end
      when 'Formation'
        ids = audit.audited_changes['formation_id']
        case ids.class.name
        when 'Integer'
          pretty_changes << "#{key} initialisée à '#{Formation.unscoped.find_by(id: ids).try(:nom)}'"
        when 'Array'
          if ids.first && ids.last 
            pretty_changes << "#{key} changée de '#{Formation.unscoped.find_by(id: ids.first).try(:nom)}' à '#{Formation.unscoped.find(ids.last).nom}'"
          elsif ids.first 
            pretty_changes << "#{key} changée de '#{Formation.unscoped.find_by(id: ids.first).try(:nom)}' à 'nil'"
          else
            pretty_changes << "#{key} changée de 'nil' à '#{Formation.unscoped.find_by(id: ids.first).try(:nom)}'"
          end
        end 
      when 'Intervenant'
        ids = audit.audited_changes['intervenant_id']
        case ids.class.name
        when 'Integer'
          pretty_changes << "#{key} initialisé à '#{Intervenant.find(ids).nom_prenom}'"
        when 'Array'
          pretty_changes << "#{key} changé de '#{Intervenant.find(ids.first).nom_prenom}' à '#{Intervenant.find(ids.last).nom_prenom}'"
        end 
      when 'User'
        ids = audit.audited_changes['user_id']
        if User.exists?(id: ids)
          case ids.class.name
          when 'Integer'
            pretty_changes << "#{key} initialisé à '#{User.find(ids).nom_prénom}'"
          when 'Array'
            pretty_changes << "#{key} changé de '#{User.find(ids.first).nom_prénom if ids.first}' à '#{User.find(ids.last).nom_prénom if ids.last}'"
          end 
        else
          pretty_changes << "Utilisateur supprimé"
        end
      when 'Debut' 
        if audit.audited_changes['debut'].class.name == 'Array'
          pretty_changes << "Horaire de début modifié de '#{I18n.l(c.last.first, format: :long)}' à '#{I18n.l(c.last.last, format: :long)}'"
        else
          pretty_changes << "Début initialisé à '#{I18n.l(c.last, format: :long)}'"
        end
      when 'Fin' 
        if audit.audited_changes['fin'].class.name == 'Array'
          pretty_changes << "Horaire de fin modifié de '#{I18n.l(c.last.first, format: :long)}' à '#{I18n.l(c.last.last, format: :long)}'"
        else
          pretty_changes << "Fin initialisée à '#{c.last}'"
        end
      when 'Etat'
        if audit.audited_changes['etat'].class.name == 'Array'
          begin
            pretty_changes << "État modifié de '#{ Cour.etats.keys[c.last.first].humanize if c.last.first }' à '#{ Cour.etats.keys[c.last.last].humanize if c.last.last }'"
          rescue => e
            pretty_changes << "/!\\ PB avec les données à convertir !"
          end
        elsif audit.audited_changes['etat'].class.name == 'Integer'
          pretty_changes << "État initialisé à '#{ Cour.etats.keys[c.last].humanize }'"
        else
          pretty_changes << "État initialisé à '#{ c.last.humanize }'"
        end
      when 'Discarded at'
        if audit.action == 'update'
          pretty_changes << "Utilisateur #{c.last.first.nil? ? 'désactivé' : 'activé'}"
        end
      when 'Signature'
        if audit.action == 'update'
          unless c.last.blank? 
            pretty_changes << 'Signature présente'
          end
        end
      else
        if audit.action == 'update'
          unless c.last.first.blank? && c.last.last.blank?  
            pretty_changes << "#{key} modifié de '#{c.last.first}' à '#{c.last.last}'"
          end
        else 
          unless c.last.blank?
            pretty_changes << "#{key} #{audit.action == 'create' ? 'initialisé à' : 'était'} '#{c.last}'"
          end
        end
      end
    end
    pretty_changes
  end

  def audited_view_path(audit)
    case audit.auditable_type
    when "User"
      if User.exists?(audit.auditable_id)
        user_path(User.find(audit.auditable_id))
      end
    when "Assemblee"
      if Assemblee.exists?(audit.auditable_id)
        assemblee_path(Assemblee.find(audit.auditable_id))
      end
    when "MailLog"
      if MailLog.exists?(audit.auditable_id)
        mail_log_path(MailLog.find(audit.auditable_id))
      end
    end
  end
end
