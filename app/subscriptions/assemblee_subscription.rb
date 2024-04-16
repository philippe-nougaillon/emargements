class AssembleeSubscription

  def on_assemblee_created(event)
    AssembleeMailer.nouvelle_assemblee(event[:payload][:assemblee_id]).deliver_now
  end

end