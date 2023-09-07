require_relative 'modules'

class Route
  attr_accessor :stations
  include InstanceCounter
  NUMBER_FORMAT = /^[A-Za-z0-9]{3}-?[A-Za-z0-9]{2}$/
  
  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def validate!
    errors = []
    errors << "Name can't be empty." if [first_station, last_station].any?(&:nil? || :empty?)
    errors << "Invalid format." unless first_station =~ NUMBER_FORMAT && last_station =~ NUMBER_FORMAT
    raise errors.join(".") unless errors.empty?
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