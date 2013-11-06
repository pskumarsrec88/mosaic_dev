class PhotosController < ApplicationController
  require 'mosaicc'
  # GET /photos
  # GET /photos.json
  
  before_filter :authentication, :except => [:index]
  
  def index
    @photos = Photo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=> @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show

    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    
    user = FbGraph::User.new('me', :access_token => User.first.token)
    
    user = user.fetch(:fields => "picture,cover, photo")
    
    @profile_picture = user.picture unless user.picture.nil?

    @cover_picture = user.raw_attributes[:cover][:source] unless user.raw_attributes[:cover].nil?
    
    #To fetch all friends photos
    @friend_photo= (user.friends).map(&:picture)    
    
    @photo=[]
    @album=[]
    
    #~ #TO fetch user tagged photos
    #~ usr=user.photos
    #~ usr.each do |up|
      #~ photo = up.raw_attributes['images'].last
      #~ @photo << photo['source']
    #~ end
    
    #~ #TO fetch user all album photos
    #~ user.albums.each do |ua|
      #~ album=FbGraph::Album.new(ua.raw_attributes[:id])
      #~ album.photos(:access_token => User.first.token, :limit => 100).each do |ap|
        #~ photo = ap.raw_attributes['images'].last
        #~ @album << photo['source']
      #~ end
    #~ end
    Mosaicc.delay.image_perform
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @album }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.json
  def create
    p params
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, :notice => 'Photo was successfully created.' }
        format.json { render :json => @photo, :status=> :created, :location=> @photo }
      else
        format.html { render :action=> "new" }
        format.json { render :json => @photo.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to @photo, :notice => 'Photo was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action=> "edit" }
        format.json { render :json => @photo.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :ok }
    end
  end
end
