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
    @trains = {} # Здесь будут храниться все поезда на станции.
  end

  def add_train(train_number, train_type) # Добавляем поезд по его ноvереу и типу "Passenger" || "Cargo".
    @trains[train_number] = train_type
    puts "Accepted a #{train_type} train with number #{train_number}"
  end

  def show_all_trains
    if @trains.empty?
      puts "No trains at the station."
    else
      puts "Trains at #{@name} station:"
      @trains.each do |train_number, train_type| # Создаем блок для отображения всех поездов и их типов
        puts "Train type: #{train_type}, Number: #{train_number}"
      end
    end
  end

  def trains_by_type(type) 
    type_trains = @trains.select { |_, train_type| train_type == type } # Отображение поездов только по типу "Passenger" || "Cargo".
    if type_trains.empty?
      puts "No #{type} trains at the station."
    else
      puts "Trains of type #{type} at #{@name} station:"
      type_trains.each do |train_number, _|
        puts "Train Number: #{train_number}"
      end
    end
  end

  def send_train(train_number) # Отправить поезд со станции.
    if @trains.key?(train_number) # Проверка если такой поезд есть, то отправляем.
      train_type = @trains.delete(train_number) # Отправленный поезд больше не находится на станции.
      puts "Sent a #{train_type} train with number #{train_number}"
    else
      puts "Train with number #{train_number} not found at the station."
    end
  end
end