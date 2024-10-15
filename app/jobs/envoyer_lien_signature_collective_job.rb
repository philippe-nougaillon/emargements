class EnvoyerLienSignatureCollectiveJob < ApplicationJob
  queue_as :default

  def perform(assemblee, user_id = 0)
    mailer_response = AssembleeMailer.lien_assemblee(assemblee).deliver_now
    MailLog.create(organisation_id: assemblee.organisation_id, user_id: user_id, message_id: mailer_response.message_id, to: assemblee.user.email, subject: "Lien signature de la session")
  end
end
