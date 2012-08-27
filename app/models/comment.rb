class Comment
  include Mongoid::Document
  
  # validates_presence_of :place_id, user_id
  
  field :content, type: String
  # field :access_token
  
  belongs_to :place
  belongs_to :user
  
end