# Класс Station (Станция):
# - Имеет название, которое указывается при ее создании
# - Может принимать поезда (по одному за раз)
# - Может возвращать список всех поездов на станции, находящиеся в текущий момент
# - Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# - Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

class Station
  attr_reader :name # Имя станции нельзя менять.

  def initialize(name) # Запрашиваем имя станции.
    @name = name 
    @trains = [] # Теперь здесь хранится массив всех поездов на станции.
  end

  def add_train(train) # Теперь просто передаем объект поезда.
    @trains << train
    puts "Accepted a #{train.type} train with number #{train.number}"
  end

  def show_all_trains
    if @trains.empty?
      puts "No trains at the station."
    else
      puts "Trains at #{@name} station:"
      @trains.each do |train|
        puts "Train type: #{train.type}, Number: #{train.number}"
      end
    end
  end

  def trains_by_type(type)
    selected_trains = @trains.select { |train| train.type == type }
    puts "Trains of type #{type} at #{@name} station:"
    selected_trains.each do |train|
      puts "Train Number: #{train.number}"
    end
    puts "Total count: #{selected_trains.count}"
    selected_trains
  end
  
  def send_train(train_number)
    train = @trains.find { |train| train.number == train_number }
    if train
      @trains.delete(train)
      puts "Sent a #{train.type} train with number #{train.number}"
    else
      puts "Train with number #{train_number} not found at the station."
    end
  end
end