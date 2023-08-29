class Train
  attr_reader :number, :speed, :carts, :trains, :carts
  attr_accessor :type

  def initialize(number, type)
    @number = number
    @type = type
    @carts = []
    @speed = 0
    @current_station_index = nil
    @route = nil
  end

  def accelerate(speed)
    @speed = speed
  end

  def brake
    @speed = 0
  end

  def attach_cart(cart)
    if @speed.zero? && cart.cart_type == @type
      @carts << cart
      puts "#{cart} has been attached to a train."
    else
      puts "Wrong type of cart or train."
    end
    if @speed > 0
      puts "Unable to detach while underway."
    end
  end

  def detach_cart(cart)
    if @speed.zero? && @carts.include?(cart)
      @carts.delete(cart)
      puts "#{cart} has been detached from a train."
    elsif @carts.empty?
      puts "There are no carts on this train."
    else
      puts 'Wrong type of cart or train.'
    end
    if @speed > 0
      puts "Unable to detach while underway."
    end
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    current_station.arrival(self)
  end

  def move_forward
    return unless next_station

    current_station.departure(self)
    @current_station_index += 1
    current_station.arrival(self)
  end

  def move_backward
    return unless previous_station

    current_station.departure(self)
    @current_station_index -= 1
    current_station.arrival(self)
  end

  def previous_station
    @route.stations[@current_station_index - 1] if @current_station_index&.positive?
  end

  def current_station
    @route.stations[@current_station_index] if @current_station_index&.between?(0, @route.stations.size - 1)
  end

  def next_station
    @route.stations[@current_station_index + 1] if @current_station_index&.between?(0, @route.stations.size - 2)
  end
end