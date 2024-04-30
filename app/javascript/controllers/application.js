import { Application } from "@hotwired/stimulus"
import "custom/companion"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
