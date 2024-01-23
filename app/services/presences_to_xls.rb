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

      headers = %w{nom_prénom id_assemblée date_assemblée date_signature}

      sheet.row(0).concat headers
      sheet.row(0).default_format = bold
      
      index = 1

      @presences.each do |presence|
        fields_to_export = [
          presence.participant.nom_prénom,
          presence.assemblee.id,
          I18n.l(presence.assemblee.début),
          I18n.l(presence.created_at)
        ]
        sheet.row(index).replace fields_to_export
        index += 1
      end
      return book

    end

end