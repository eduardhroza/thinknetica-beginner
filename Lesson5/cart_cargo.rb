class CartCargo < Cart
  def initialize
    @type = :cargo
    super
  end
end