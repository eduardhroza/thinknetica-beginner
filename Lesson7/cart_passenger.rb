class CartPassenger < Cart
  def initialize(seats)
    @type = :passenger
    super(seats)
  end

  def take_seat
    @used_seats += 1
  end
end