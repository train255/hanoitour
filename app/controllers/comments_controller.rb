class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  # def index
  #   @comments = Comment.all
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: [@place, @comment] }
  #   end
  # end
  # 
  # # GET /comments/1
  # # GET /comments/1.json
  # def show
  #   @comment = Comment.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: [@place, @comment] }
  #   end
  # end

  # GET /comments/new
  # GET /comments/new.json
  # def new
  #   @comment = Comment.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: [@place, @comment] }
  #   end
  # end

  # GET /comments/1/edit
  # def edit
  #   @comment = Comment.find(params[:id])
  # end

  # POST /comments
  # POST /comments.json
  def create
    # binding.pry
    @place = Place.find(params[:place_id])
    
    token = params[:comment][:access_token]
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
        @comment = @place.comments.build(params[:comment])
        @success = @comment.save
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

  # PUT /comments/1
  # PUT /comments/1.json
  # def update
  #   @comment = Comment.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @comment.update_attributes(params[:comment])
  #       format.html { redirect_to [@place, @comment], notice: 'Comment was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @comment.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @place = Place.find(params[:place_id])
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @place }
      format.json { head :no_content }
    end
  end
end
