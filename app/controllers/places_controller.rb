class PlacesController < ApplicationController
  # before_filter :authenticate_user!
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
    # binding.pry
    @place = Place.find(params[:id])
    @place_json = Place.find(params[:id]).as_json({ :properties => :all })
    @json = Place.find(params[:id]).to_gmaps4rails
    @comments = @place.comments
    @rates = @place.rates

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {:place_info => @place_json, :comments => @comments, :rating => @place.average_rating} }
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
    @place.comments.delete_all
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url }
      format.json { head :no_content }
    end
  end
  
  def rate_and_comment
    @place = Place.find(params[:id])
    
    token = params[:place][:access_token]
    url = URI.parse('https://www.googleapis.com/oauth2/v1/tokeninfo?access_token='+token)
    connection = Net::HTTP.new(url.host, url.port)
    connection.use_ssl = true
    response = connection.request_get(url.path + '?' + url.query)
    data = JSON.parse(response.body)
    
    if data["error"].present?
      @result = data["error"]
      @success = false
    else
      @result = data["email"]
      @user = User.find_for_server(@result)
      if @user.present?
        #rate
        if Rate.where(place_id: @place.id, user_id: @user.id).count == 1
          @rate = Rate.where(place_id: @place.id, user_id: @user.id).first
          @rate.update_attribute(:value, params[:place][:user_rate_value])
        else
          @rate = @place.rates.build
          @rate.value = params[:place][:user_rate_value]
          @rate.user_id = @user.id
        end
        
        #comment
        @comment = @place.comments.build
        @comment.content = params[:place][:comment_content]
        @comment.user = @user
        
        if @comment.save && @rate.save
          @success = true
        else
          @success = false
        end
      end
    end
    
    respond_to do |format|
      if @success
        format.html { redirect_to @place, notice: 'Comment was successfully created.' }
        format.json { render json: @place, status: :created, location: @comment }
      else
        format.html { redirect_to @place, notice: @result }
        format.json { render json: {error: "invalid_token"} }
      end
    end
  end
  
end
