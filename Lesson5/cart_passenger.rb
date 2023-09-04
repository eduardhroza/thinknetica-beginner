class CartPassenger < Cart
  def initialize
    @type = :passenger
    super
  end
end