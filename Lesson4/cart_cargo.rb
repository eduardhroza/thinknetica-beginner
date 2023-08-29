class CartCargo < Cart
  
  attr_accessor :type
  def initialize
    super('Cargo')
  end
end