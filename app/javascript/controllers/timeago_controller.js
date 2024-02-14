import { Controller, Application } from "@hotwired/stimulus"
import Timeago from 'stimulus-timeago'

const application = Application.start()
application.register('timeago', Timeago)

// Connects to data-controller="timeago"
export default class extends Controller {
  connect() {
    console.log('Timeago controller connected')
  }
}
