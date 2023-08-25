# Класс Route (Маршрут):
# - Имеет начальную и конечную станцию, а также список промежуточных станций. 
#   Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# - Может добавлять промежуточную станцию в список.
# - Может удалять промежуточную станцию из списка.
# - Может выводить список всех станций по-порядку от начальной до конечной.

class Route
  attr_reader :stations
  
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
end