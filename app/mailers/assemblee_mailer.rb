class AssembleeMailer < ApplicationMailer
  def lien_assemblee(assemblee)
    @assemblee = assemblee
    mail(to: @assemblee.user.nom, subject: "Émargement de l'assemblée '#{@assemblee.nom}'")
  end
end
