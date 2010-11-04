require 'test_helper'

class DeliverablesControllerTest < ActionController::TestCase

  def test_should_get_index_without_login
    login_as nil
    get :index
    assert_redirected_to login_google_url
  end

  def test_should_get_index_with_student
    login_as :student_anooj
    get :index
    assert_response :success
    assert_not_nil assigns(:deliverables)
  end

  def test_should_get_empty_index_with_student
    login_as :student_sam
    get :index
    assert_response :success
    assert_equal [], assigns(:deliverables)
  end

  def test_should_get_all_student_deliverables
    login_as :faculty_francine
    get :index
    assert_response :success
    assert_not_nil assigns(:deliverables)
  end

  def test_should_get_new
    login_as :student_sam
    get :new, :team_id => 1
    assert_response :success
    assert_not_nil assigns(:teams)
  end

  def test_should_create_deliverable
    login_as :student_sam
    assert_difference('Deliverable.count') { post :create,
                                                  :deliverable => {
                                                          :person_id => users(:student_anooj).id,
                                                          :team_id => 1,
                                                          :individual => true,
                                                          :deliverable => sample_file("testfile.png")
                                                  } }

    assert_redirected_to deliverable_path(assigns(:deliverable))
  end

  def test_should_show_deliverable
    login_as :student_sam
    get :show, :id => deliverables(:one).id
    assert_response :success
  end

  def test_should_get_edit
    login_as :student_sam
    get :edit, :id => deliverables(:one).id
    assert_response :success
  end

  def test_should_update_deliverable
    login_as :student_sam
    put :update, :id => deliverables(:one).id, :deliverable => { :individual => false }
    assert_redirected_to deliverable_path(assigns(:deliverable))
  end

  def test_should_update_deliverable_with_feedback
    login_as :faculty_francine
    put :update, :id => deliverables(:one).id, :deliverable => { :feedback => sample_file("testfile2.png") }
    assert_redirected_to deliverable_path(assigns(:deliverable))
  end


end
