class PresencesToXls < ApplicationService
    require 'spreadsheet'
    attr_reader :presences
    private :presences

    def initialize(presences)
      @presences = presences
    end

    def call
      Spreadsheet.client_encoding = 'UTF-8'
    
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet name: @presences.name
      bold = Spreadsheet::Format.new :weight => :bold, :size => 11

      headers = %w{nom_participant prénom_participant tags_participant id_assemblée date_assemblée nom_assemblée date_signature chevauchement_assemblée}

      sheet.row(0).concat headers
      sheet.row(0).default_format = bold
      
      index = 1

      @presences.each do |presence|
        fields_to_export = [
          presence.user.nom,
          presence.user.prénom,
          presence.user.tag_list.join(', '),
          presence.assemblee.id,
          I18n.l(presence.assemblee.début),
          presence.assemblee.nom,
          I18n.l(presence.created_at),
          presence.check_chevauchement ? "CHEVAUCHEMENT!!!" : ""
        ]
        sheet.row(index).replace fields_to_export
        index += 1
      end
      return book

    end

end