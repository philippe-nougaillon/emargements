class AssembleesToIcalendar < ApplicationService
  require 'icalendar'
  attr_reader :assemblees

  def initialize(assemblees)
    @assemblees = assemblees
  end

  def call
    
    calendar = Icalendar::Calendar.new

    calendar.timezone do |t|
      t.tzid = "Europe/Paris"
    end
    
    assemblees.each do | a |
      event = Icalendar::Event.new
      event.dtstart = a.début.strftime("%Y%m%dT%H%M%S")
      event.dtend = a.fin.strftime("%Y%m%dT%H%M%S")
      event.summary = a.nom
      event.description = a.tag_list.join(', ')
      event.location = a.adresse
      calendar.add_event(event)
    end
    return calendar.to_ical
  end
end