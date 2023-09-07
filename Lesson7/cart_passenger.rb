class CartPassenger < Cart

  NUMBER_FORMAT = /\A([1-9]|1\d|25)\z/

  def initialize(seats)
    @type = :passenger
    @seats = seats.to_s
    @used_seats = 0
    @@current_number += 1
    @number = @@current_number
    super()
  end

  def occupied_seats
    @seats.to_i - @used_seats
  end

  def free_seats
    @seats.to_i - @used_seats
  end

  def take_seat
    @used_seats += 1
  end

  def validate!
    errors = []
    errors << "Number of seats can't be empty." if @seats.nil? || @seats == ""
    errors << "Invalid number of seats. Must be a number from 1 to 25." unless @seats =~ NUMBER_FORMAT
    raise errors.join(".") unless errors.empty?
  end
  
end