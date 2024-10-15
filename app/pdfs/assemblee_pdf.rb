class AssembleePdf
  include Prawn::View

  def initialize
    @margin_down = 15
    @image_path = "#{Rails.root}/app/assets/images/"
  end

  def convocation(assemblee)
    users = User.where(id: assemblee.related_users)
    users.ordered.each_with_index do |user, index|
      start_new_page unless index == 0

      if assemblee.organisation.logo.attached?
        image StringIO.open(assemblee.organisation.logo.download), :height => 100
        move_down @margin_down * 2
      end

      text assemblee.organisation.nom, size: 14
      move_down @margin_down * 2
      text "<b>CONVOCATION</b>", inline_format: true, size: 16, align: :center
      move_down @margin_down * 4
      text "Bonjour #{user.prénom_nom},"
      move_down @margin_down
      text "Vous êtes convoqué à la session '<b>#{assemblee.nom}</b>' qui aura lieu le <b>#{I18n.l(assemblee.début, format: :long)}</b>", inline_format: true
      
      unless assemblee.adresse.blank?
        move_down @margin_down * 2     
        text "Adresse de la session :"
        move_down @margin_down      
        text "#{assemblee.adresse}"
      end 

      unless assemblee.organisation.premium?
        move_down @margin_down * 25
        image "#{@image_path}/logo_signature.png", :width => 25, position: :center
        move_down @margin_down
        text "<u><a href='https://emargements.philnoug.com/'>Convocation réalisée gratuitement</a></u>", align: :center, inline_format: true
      end
    end
  end
  
end