require_relative 'car2'
require_relative 'truck'
require_relative 'sport_car'

truck = Truck.new
truck.start_engine
puts "Current RPM: #{truck.current_rpm}"