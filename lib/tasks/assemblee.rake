namespace :assemblee do

  desc "Envoyer le mail aux gestionnaires des assemblées qui vont commencer"
  task :send_link, [:enregistrer] => :environment do |task, args|
    Assemblee.where(automatique: true).where("assemblees.début BETWEEN ? AND ?", DateTime.now - 10.minutes, DateTime.now).each do |assemblee|
      # TODO : A placer dans un Job
      mailer_response = AssembleeMailer.lien_assemblee(assemblee).deliver_now
      MailLog.create(organisation_id: assemblee.organisation_id, user_id: 0, message_id: mailer_response.message_id, to: assemblee.user.email, subject: "Lien assemblée gestionnaire automatique")
    end
    Assemblee.where(notifier_participants: true).where("assemblees.début BETWEEN ? AND ?", DateTime.now - 10.minutes, DateTime.now).each do |assemblee|
      User.where(id: assemblee.related_users).each do |user|
        # TODO : A placer dans un Job
        mailer_response = AssembleeMailer.lien_assemblee_participant(assemblee).deliver_now
        MailLog.create(organisation_id: assemblee.organisation_id, user_id: 0, message_id: mailer_response.message_id, to: user.email, subject: "Lien assemblée participant automatique")
      end
    end
  end

end