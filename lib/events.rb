require 'dry/events/publisher'

class Events
  include Singleton
  include Dry::Events::Publisher[:my_publisher]

  register_event('assemblee.created', 'organisation.created')
end