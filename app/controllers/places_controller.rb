class PlacesController < ApplicationController
  # GET /places
  # GET /places.json
  def index
    @places = Place.all
    @places_json = Place.all.as_json({ :properties => :short })
    @json = Place.all.to_gmaps4rails

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @places_json }
    end
  end

  # GET /places/1
  # GET /places/1.json
  def show
    @place = Place.find(params[:id])
    @place_json = Place.find(params[:id]).as_json({ :properties => :all })
    @json = Place.find(params[:id]).to_gmaps4rails

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @place_json }
    end
  end

  # GET /places/new
  # GET /places/new.json
  def new
    @place = Place.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
    @json = Place.find(params[:id]).to_gmaps4rails
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(params[:place])

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render json: @place, status: :created, location: @place }
      else
        format.html { render action: "new" }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.json
  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url }
      format.json { head :no_content }
    end
  end
end
