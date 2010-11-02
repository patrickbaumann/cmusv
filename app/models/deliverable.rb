class Deliverable < ActiveRecord::Base

  belongs_to :team
  belongs_to :person

  validates_presence_of :person_id
  validates_presence_of :team_id
  validates_presence_of :deliverable_file_name


  has_attached_file :deliverable,
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
      :path => "deliverables/:id/:filename/:version"
  has_attached_file :feedback,
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
      :path => "deliverables/feedback/:id/:filename"


  def canView?(person)
    # let's extract the id of a Person object or convert to an integer if other object type
    pid = (person.class == Person or person.class == User) ? person.id : person.to_i

    # now either they're the submitter, or a team member of a team submission
    return true if (person_id == pid) # is the submitter
    return true if (!individual and team.people.collect{|p| p.id}.include?(pid)) # is a member of a team deliverable
    return true if Person.find(pid).is_teacher # is a staff member
    false
  end

end
