class AssembleeMailer < ApplicationMailer
  def lien_assemblee(assemblee)
    @assemblee = assemblee
    mail(to: @assemblee.user.email, subject: "Émargement de l'assemblée '#{@assemblee.nom}'")
  end

  def lien_assemblee_participant(assemblee)
    @assemblee = assemblee
    User.where(id: @assemblee.related_users).each do |user|
      @user = user
      mail(to: @user.email, subject: "Émargement de l'assemblée '#{@assemblee.nom}'")
    end
  end
end
