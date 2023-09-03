# Класс Route (Маршрут):
require_relative 'modules'

class Route
  attr_accessor :stations
  include InstanceCounter
  
  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def add_intermediate_station(station)
    @stations.insert(-2, station)
  end

  def remove_intermediate_station(station)
    @stations.delete(station)
  end

  def display_stations
    puts "Stations:"
    @stations.each { |station| puts station.name }
  end

  def station_list
    @stations
  end
end