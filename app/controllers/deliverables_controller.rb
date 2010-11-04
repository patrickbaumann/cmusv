class DeliverablesController < ApplicationController
   layout 'cmu_sv'

   before_filter :require_user

  # GET /deliverables
  # GET /deliverables
  def index
    if current_user.is_teacher?
      @deliverables = Deliverable.find(:all)       
    elsif current_user.is_student?
      @deliverables = Deliverable.find(:all, :conditions => {:person_id => current_person.id})
      @deliverables += Deliverable.find(:all, :conditions => {:team_id => current_person.teams.collect{|t| t.id}, :individual => false})
      @deliverables.uniq!
    end
  end

  # GET /deliverables/1
  # GET /deliverables/1.xml
  def show
    @deliverable = Deliverable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deliverable }
    end
  end

  # GET /deliverables/new
  # GET /deliverables/new.xml
  def new
    @deliverable = Deliverable.new
    @deliverable.team_id = current_person.teams.find(:first, :conditions => {:course_id => params[:course_id]}) if params[:course_id]
    @deliverable.person_id = current_person.id
    @teams = current_person.teams
    @teams_courses_select = teams_courses_select(@teams)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deliverable }
    end
  end

  # GET /deliverables/1/edit
  def edit
    @deliverable = Deliverable.find(params[:id])
    @teams = current_person.teams
    @teams_courses_select = teams_courses_select(@teams)
  end

  # POST /deliverable
  # POST /deliverable.xml
  def create
    @deliverable = Deliverable.new(params[:deliverable])
    @teams = current_person.teams
    @teams_courses_select = teams_courses_select(@teams)
    respond_to do |format|
      if @deliverable.save
        flash[:notice] = 'Deliverable was successfully created.'
        format.html { redirect_to(@deliverable) }
        format.xml  { render :xml => @deliverable, :status => :created, :location => @deliverable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deliverables/1
  # PUT /deliverables/1.xml
  def update
    @deliverable = Deliverable.find(params[:id])
    @teams = current_person.teams
    @teams_courses_select = teams_courses_select(@teams)
    
    respond_to do |format|
      if @deliverable.update_attributes(params[:deliverable])
        flash[:notice] = 'Deliverable was successfully updated.'
        format.html { redirect_to(@deliverable) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
    end
  end

private  
  def teams_courses_select(teams)
    teams_courses_select_ret = {}
    teams.collect{|t| [t.course.name, t.id]}.each do |x|
      teams_courses_select_ret[x[0]] = x[1]
    end
  end

end
