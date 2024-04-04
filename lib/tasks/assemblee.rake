namespace :assemblee do

  desc "Envoyer le mail aux gestionnaires des assemblées qui vont commencer"
  task :send_link, [:enregistrer] => :environment do |task, args|
    Assemblee.where(automatique: true).where("assemblees.début BETWEEN ? AND ?", DateTime.now - 10.minutes, DateTime.now).each do |assemblee|
      mailer_response = AssembleeMailer.lien_assemblee(assemblee).deliver_now
      MailLog.create(user_id: 0, message_id: mailer_response.message_id, to: assemblee.user.email, subject: "Lien assemblée gestionnaire")
    end
    Assemblee.where(notifier_participants: true).where("assemblees.début BETWEEN ? AND ?", DateTime.now - 10.minutes, DateTime.now).each do |assemblee|
      User.where(id: assemblee.related_users).each do |user|
        mailer_response = AssembleeMailer.lien_assemblee_participant(assemblee).deliver_now
        MailLog.create(user_id: 0, message_id: mailer_response.message_id, to: user.email, subject: "Lien assemblée participant")
      end
    end
  end

end