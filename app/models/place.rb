class Place
  include Mongoid::Document
  include Mongoid::CachedJson
  include Gmaps4rails::ActsAsGmappable
  
  field :name, type: String
  field :latitude, type: Float
  field :longitude, type: Float
  field :address, type: String
  field :image, type: String
  field :info, type: String
  field :gmaps, type: Boolean
  
  attr_accessor :comment_content
  attr_accessor :access_token
  attr_accessor :user_rate_value
  
  has_many :comments
  has_many :rates
  
  json_fields \
    :id => { :type => :reference },
    :name => { :type => :reference },
    :latitude => { :type => :reference },
    :longitude => { :type => :reference },
    :address => { :type => :reference },
    :image => { :type => :reference, :properties => :public },
    :info => { :type => :reference, :properties => :public }

  acts_as_gmappable
  
  def gmaps4rails_address
    self.address
  end
  
  def gmaps4rails_sidebar
    self.name
  end
  
  def gmaps4rails_infowindow
    "<h1>#{name}</h1>"
  end
  
  def average_rating
    if rates.count > 0
      rates.map { |rate| rate.value }.inject{ |sum, el| sum + el }.to_f / rates.count
    else
      0
    end
  end
  
end
