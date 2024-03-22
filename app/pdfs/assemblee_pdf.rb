class AssembleePdf
  include Prawn::View

  def initialize
    @margin_down = 15
    @image_path =  "#{Rails.root}/app/assets/images/"
  end

  def convocation(assemblee)
    User.ordered.each_with_index do |user, index|
      start_new_page unless index == 0
      image "#{@image_path}/ceser.png", :width => 100, position: :center
      move_down @margin_down
      text "<b>CESER - Grand Est<b>", inline_format: true, size: 16
      text "1 Pl. Adrien Zeller"
      text "67000 Strasbourg"
      move_down @margin_down * 4
      text "<b>CONVOCATION</b>", inline_format: true, size: 16, align: :center
      move_down @margin_down * 4
      text "Bonjour #{user.prénom_nom},"
      move_down @margin_down
      text "Vous êtes convoqué à l'assemblée '<b>#{assemblee.nom}</b>' qui aura lieu <b>#{assemblee.adresse}</b>, le <b>#{I18n.l(assemblee.début, format: :long)}</b>", inline_format: true
      # move_down @margin_down * 5
      # text "Voici plusieurs trajets pour y aller depuis chez vous :"

      # move_down @margin_down
      # y_position = cursor
      # bounding_box([0, y_position], :width => 125) do
      #   text "En transports", align: :center
      #   image "#{@image_path}/trajet.png", :width => 100, position: :center
      #   move_down @margin_down
      #   text "Émission CO2 : 0.8kg", align: :center
      #   text "Durée : 30min", align: :center
      # end
      # bounding_box([130, y_position], :width => 125) do
      #   text "À pied", align: :center
      #   image "#{@image_path}/trajet.png", :width => 100, position: :center
      #   move_down @margin_down
      #   text "Émission CO2 : 0g", align: :center
      #   text "Durée : 3h", align: :center
      # end
      # bounding_box([260, y_position], :width => 125) do
      #   text "En voiture", align: :center
      #   image "#{@image_path}/trajet.png", :width => 100, position: :center
      #   move_down @margin_down
      #   text "Émission CO2 : 6kg", align: :center
      #   text "Durée : 20min", align: :center
      # end

      # bounding_box([390, y_position], :width => 125) do
      #   text "En voiture", align: :center
      #   image "#{@image_path}/trajet.png", :width => 100, position: :center
      #   move_down @margin_down
      #   text "Émission CO2 : 0g", align: :center
      #   text "Durée : 1h", align: :center
      # end

      # move_down @margin_down * 25
      # text "<u><a href='https://www.fluo.eu/'>Voir les itinéraires avec Fluo</a></u>", align: :center, inline_format: true
      # image "#{@image_path}/fluo.png", :width => 100, position: :center
    end
  end
end