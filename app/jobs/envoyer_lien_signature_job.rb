class EnvoyerLienSignatureJob < ApplicationJob
  queue_as :default

  def perform(assemblee, user)
    mailer_response = AssembleeMailer.lien_assemblee_participant(assemblee, user).deliver_now
    MailLog.create(organisation_id: assemblee.organisation_id, user_id: 0, message_id: mailer_response.message_id, to: user.email, subject: "Lien signature assemblée")
  end
end
