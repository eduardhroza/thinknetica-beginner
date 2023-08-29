class CartPassenger < Cart
  
  attr_accessor :type
  def initialize
    super('Passenger')
  end
end