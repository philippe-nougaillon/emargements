namespace :assemblee do

  desc "Envoyer le mail aux gestionnaires des assemblées qui vont commencer"
  task :send_link, [:enregistrer] => :environment do |task, args|
    Assemblee.where(automatique: true).where("assemblees.début BETWEEN ? AND ?", DateTime.now - 10.minutes, DateTime.now).each do |assemblee|
      AssembleeMailer.lien_assemblee(assemblee).deliver_now
    end
    Assemblee.where(notifier_participants: true).where("assemblees.début BETWEEN ? AND ?", DateTime.now - 10.minutes, DateTime.now).each do |assemblee|
      AssembleeMailer.lien_assemblee_participant(assemblee).deliver_now
    end
  end

end