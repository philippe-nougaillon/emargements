# Preview all emails at http://localhost:3000/rails/mailers/assemblee_mailer
class AssembleeMailerPreview < ActionMailer::Preview

  def lien_assemblee
    AssembleeMailer.lien_assemblee(Assemblee.first)
  end

  def lien_assemblee_participant
    AssembleeMailer.lien_assemblee_participant(Assemblee.first, User.first)
  end
end
