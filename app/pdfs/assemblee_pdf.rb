class AssembleePdf
  include Prawn::View

  def initialize
    @margin_down = 15
    @image_path =  "#{Rails.root}/app/assets/images/"
  end

  def convocation(assemblee)
    User.ordered.each_with_index do |user, index|
      start_new_page unless index == 0
      text "<color rgb='032E4D'><b>Convocation</b></color>", inline_format: true, size: 16, style: :bold, align: :center
      text "Bonjour #{user.prénom_nom},"
      move_down @margin_down
      text "Vous êtes convoqué à #{assemblee.nom} à #{assemblee.adresse} le #{I18n.l(assemblee.début, format: :long)}"
      move_down @margin_down
      text "Voici plusieurs trajets pour y aller depuis chez vous :"

      move_down @margin_down
      y_position = cursor
      bounding_box([0, y_position], :width => 176) do
        text "En transport en commun", align: :center
        image "#{@image_path}/trajet.png", :width => 120, position: :center
      end
      bounding_box([176, y_position], :width => 176) do
        text "À pied", align: :center
        image "#{@image_path}/trajet.png", :width => 120, position: :center
      end
      bounding_box([353, y_position], :width => 176) do
        text "En voiture (8x plus de CO2 a a a a qu'en transport)", align: :center
        image "#{@image_path}/trajet.png", :width => 120, position: :center
      end
    end
  end
end