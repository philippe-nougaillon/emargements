class PresencePdf
  include Prawn::View
  require 'base64'

  def initialize
    @margin_down = 15
  end

  def rapport(presences, assemblee)
    text "Feuille d'émargement", size: 36, align: :center
    text assemblee.nom, size: 36, align: :center
    move_down @margin_down

    presences.each_with_index do |presence, index|
      start_new_page if (index%4 == 3)

      text presence.user.nom_prénom, size: 20
      text "Le #{I18n.l presence.heure, format: :long}"
      text presence.assemblee.nom.humanize, size: 16
  
      svg Base64.decode64(presence.signature.split(',')[1]), width: 200
      move_down @margin_down

      stroke_horizontal_rule unless index%4 == 2
      move_down @margin_down
    end
  end

end