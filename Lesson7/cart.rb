class Cart
  attr_accessor :type, :used_seats, :seats, :total_volume, :occupied_volume, :number
  include Manufacturer
  @@current_number = 0
end