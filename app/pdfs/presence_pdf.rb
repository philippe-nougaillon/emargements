class PresencePdf
  include Prawn::View
  require 'base64'

  def initialize
    @margin_down = 15
  end

  def rapport(presences)
    presences.each do |presence|
      text "#{presence.user.nom_prénom}", size: 20
      text "#{presence.assemblee.nom.humanize}", size: 16
      svg Base64.decode64(presence.signature.split(',')[1]), width: 200
      text "#{I18n.l presence.heure, format: :long}"
      move_down @margin_down
      stroke_horizontal_rule
      move_down @margin_down
    end
  end
end