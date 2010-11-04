class Deliverable < ActiveRecord::Base

  belongs_to :team
  belongs_to :person

  validates_presence_of :person_id
  validates_presence_of :team_id
  validates_presence_of :deliverable_file_name

  acts_as_versioned

  has_attached_file :deliverable,
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
      :path => "deliverables/:id/:filename/:version",
      :keep_old_files => true
  has_attached_file :feedback,
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
      :path => "deliverables/feedback/:id/:filename"

  Paperclip.interpolates :version do |d,f|
    d.instance.version.to_s
  end

  def canView?(person)
    # let's extract the id of a Person object or convert to an integer if other object type
    pid = (person.class == Person or person.class == User) ? person.id : person.to_i

    # now either they're the submitter, or a team member of a team submission
    return true if (person_id == pid) # is the submitter
    return true if (!individual and team.people.collect{|p| p.id}.include?(pid)) # is a member of a team deliverable
    return true if Person.find(pid).is_teacher # is a staff member
    false
  end

  def title
    return read_attribute(:title) if not read_attribute(:title).nil?
    #return nil if !person or !team
    if individual
      out = "#{person.first_name}_#{person.last_name}"
    else
      out = "#{team.name}"
    end
    out += "_#{team.course.name}#{task_number ? "_task_#{task_number}" : ""}_#{deliverable_file_name}"
    return out
  end
end
