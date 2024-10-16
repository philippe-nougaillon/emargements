class EmailSubscription

  def on_organisation_created(event)
    user = User.find(event[:payload][:user_id])
    UserMailer.welcome(user).deliver_later
  end

  def on_assemblee_created(event)
    AssembleeMailer.nouvelle_assemblee(event[:payload][:assemblee_id]).deliver_later
  end

end