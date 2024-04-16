Rails.application.config.after_initialize do
  events = Events.instance

  events.subscribe(EmailSubscription.new)
end