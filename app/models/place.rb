class Place
  include Mongoid::Document
  include Gmaps4rails::ActsAsGmappable
  
  field :name, type: String
  field :latitude, type: Float
  field :longitude, type: Float
  field :address, type: String
  field :image, type: String
  field :info, type: String
  field :rate, type: Float
  field :numberOfRate, type: Integer
  field :gmaps, type: Boolean
  
  acts_as_gmappable
  
  def gmaps4rails_address
    self.address
  end
  
  def gmaps4rails_sidebar
    name
  end
  
  def gmaps4rails_infowindow
    "<h1>#{name}</h1>"
  end
  
end
