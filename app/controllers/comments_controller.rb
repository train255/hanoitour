class CommentsController < ApplicationController
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
