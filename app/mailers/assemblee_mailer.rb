class AssembleeMailer < ApplicationMailer
  def lien_assemblee(assemblee)
    @assemblee = assemblee
    mail(to: User.first, subject: "Lien de signature de l'assemblée")
  end
end
