class AssembleeSubscription

  def on_assemblee_created(event)
    AssembleeMailer.nouvelle_assemblee(event[:payload].first.last).deliver_now
  end

end