class DeliverableMailer < ActionMailer::Base

  def update_professor(deliverable)
    sender = (deliverable.individual ? deliverable.person.human_name : deliverable.team.name )
    recips = [deliverable.team.primary_faculty.email]
    recips << deliverable.team.secondary_faculty.email if deliverable.team.secondary_faculty
    action = deliverable.versions.size > 1 ? "updated" : "submitted"
    recipients recips
    from deliverable.person.email
    subject "Deliverable #{action} by #{sender}" +

    if(deliverable.individual)
      cc deliverable.team.people.collect{|p| p.email if p != deliverable.person}.compact
    end
    sent_on Time.now

    temp_body =
            "#{sender} has #{action} the following deliverable for #{deliverable.team.course.name}" +
            "#{deliverable.task_number ? ", task #{deliverable.task_number.to_s}" : ""}. For further" +
            " information about this deliverable, please visit #{deliverable_url(deliverable)}. You" +
            " can find the file attached to this deliverable at #{deliverable.deliverable.url}"
    body temp_body
  end

end