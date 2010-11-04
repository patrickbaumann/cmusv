require 'test_helper'

class DeliverableTest < ActiveSupport::TestCase

  def test_valid_attributes
    d = Deliverable.new
    assert !(d.save), "should not save without required attributes"
    
    d.person_id = 1
    d.deliverable_file_name = "test"
    d.team_id = 1
    d.individual = true
           
    assert d.save, "should save with required fields"

    d.comments = "testing testing testing"
    d.task_number = 1
    
    assert d.save, "should still save with optional fields"
  end

  def test_team_upload
    d = Deliverable.new
    d.person_id = 1
    d.deliverable_file_name = "test"
    d.team_id = teams(:one).id
    d.individual = false
    assert d.save, "Should save with team information"
    assert_equal d.team.name, "Team Alpha", "Should be classified as a team upload"
    assert !d.individual?, "Should save as an individual deliverable"  
  end
 
  def test_individual_upload
    d = Deliverable.new
    d.person_id = 1
    d.deliverable_file_name = "test"
    d.team_id = teams(:one).id
    d.individual = true
    
    assert d.save, "Should save with team information"
    assert d.individual?, "Should save as an individual deliverable"  
  end

  def test_reupload_versioning
    d = Deliverable.new
    d.person_id = 1
    d.deliverable_file_name = "test"
    d.team_id = teams(:one).id
    d.individual = true
    
    d.save
    
    d.deliverable_file_name = "test2"
    d.save
    
    assert_equal 2, d.versions.count, "should have two versions after second save"
  end
  
  def test_faculty_file_view
    d = Deliverable.new
    d.person_id = 1
    d.deliverable_file_name = "test"
    d.team_id = teams(:teamOne)
    d.individual = true
    d.save
    
    assert d.canView?(users(:faculty_francine)), "team faculty should be able to view with user object passed"
    assert d.canView?(99), "team faculty (2) should be able to view with id passed"
  end

  def test_faculty_file_response_upload
    d = Deliverable.new
    d.person_id = 1
    d.deliverable_file_name = "test"
    d.team_id = 1
    d.individual = true
    assert d.save, "should save with required fields"
    
    d.feedback_file_name = "test"
    assert d.save, "should save with factulty file fields"
  end
  
  def test_file_permissions
    d = Deliverable.new
    d.person_id = 1
    d.deliverable_file_name = "test"
    d.team_id = teams(:teamOne)
    d.individual = true
    d.save
    assert d.canView?(1), "uploader can view file"
    assert !d.canView?(2), "team member cannot view individual file file"
      
    d.individual = false
    d.save
    assert d.canView?(1), "uploader can view file"
    assert d.canView?(2), "team member can view file"
    assert !d.canView?(3), "non team member can view file"
  end

  def test_auto_title
    d = Deliverable.new
    d.person_id = 1
    d.deliverable_file_name = "test"
    d.team_id = teams(:teamOne)
    d.individual = true
    d.save
    assert_equal "Mr._quentin_Foundations of Software Engineering_test", d.title

    d.individual = false
    d.save
    assert_equal "team francine_Foundations of Software Engineering_test", d.title

    d.task_number = 5
    d.save
    assert_equal "team francine_Foundations of Software Engineering_task_5_test", d.title

    d.title = "testing!"
    d.save

    assert_equal "testing!", d.title
  end
    
end
