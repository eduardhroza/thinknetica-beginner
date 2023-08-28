# Класс Station (Станция):

class Station
  attr_reader :name, :stations
  attr_accessor :trains

  def initialize(name) 
    @name = name 
    @trains = [] 
  end

  def add_train(train)
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

  private def trains_by_type(type) # Этот метод не будет вызываться из клиентского кода
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

  def arrival(train)
    @trains << train
  end

  def departure(train)
    @trains.delete(train)
  end
end