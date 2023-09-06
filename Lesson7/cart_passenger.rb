class CartPassenger < Cart
  def initialize(seats)
    @type = :passenger
    super
  end

  def take_seat
    @used_seats += 1
  end
end