class Comment
  include Mongoid::Document
  
  validates_presence_of :place_id
  
  field :content, type: String
  
  belongs_to :place
  
end