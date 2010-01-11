class RepositoriesController < ApplicationController
  # GET /repositories
  # GET /repositories.xml
  def index
    @repositories = Repository.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @repositories }
    end
  end

  # GET /repositories/1
  # GET /repositories/1.xml
  def show
    @repository = Repository.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  def find_owner
    owner_id = session[:user_id]
    owner = User.find(owner_id)
    owner
  rescue
    logger.error("Log in")
    flash[:notice] = "not logged in"
    nil
  end

  # GET /repositories/new
  # GET /repositories/new.xml
  def new
    @owner = find_owner
    if @owner == nil
        redirect_to :action => 'index'
        return
    end
    @repository = Repository.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/1/edit
  def edit
    @repository = Repository.find(params[:id])
  end

  # POST /repositories
  # POST /repositories.xml
  def create
    @owner = find_owner
    if @owner == nil
        redirect_to :action => 'index'
        return
    end
    @repository = Repository.new(params[:repository])
#    @repository.owner_id = session[:user_id]
    @owner.addRepository(@repository)
    respond_to do |format|
      if @owner.save
        flash[:notice] = 'Repository was successfully created.'
        format.html { redirect_to(@repository) }
        format.xml  { render :xml => @repository, :status => :created, :location => @repository }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.xml
  def update
    @repository = Repository.find(params[:id])

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        flash[:notice] = 'Repository was successfully updated.'
        format.html { redirect_to(@repository) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.xml
  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to(repositories_url) }
      format.xml  { head :ok }
    end
  end
end
