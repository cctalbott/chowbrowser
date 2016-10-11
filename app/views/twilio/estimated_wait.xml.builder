xml.instruct!
xml.Response do
  xml.Gather(:action => @postto) do
    xml.Say "Please enter the estimated wait time in minutes for this order to be completed and press the pound key when finished.", :loop => 4
  end
end
