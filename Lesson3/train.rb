# Класс Train (поезд):

# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
# Может набирать скорость
# Может возвращать текущую скорость
# Может тормозить (сбрасывать скорость до нуля)
# Может возвращать количество вагонов
# Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# Может принимать маршрут следования (объект класса Route). 
# При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута


class Train
  attr_reader :number, :type, :speed, :car_count

  def initialize(number, type, car_count)
    @number = number
    @type = type
    @car_count = car_count
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

  def attach_car
    @car_count += 1 if @speed.zero?
  end

  def detach_car
    @car_count -= 1 if @speed.zero? && @car_count > 0
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

class Route
  attr_reader :stations

  def initialize(stations)
    @stations = stations
  end

  def station_list
    @stations
  end
  
end

class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrival(train)
    @trains << train
  end

  def departure(train)
    @trains.delete(train)
  end
end