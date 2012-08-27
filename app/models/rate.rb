class Rate
  include Mongoid::Document
  
  field :value, type: Float
  
  belongs_to :place
  belongs_to :user
  
end
