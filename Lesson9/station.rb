# frozen_string_literal: true

require_relative 'modules'

class Station
  attr_reader :name, :stations
  attr_accessor :trains

  include InstanceCounter
  include Validation
  NUMBER_FORMAT = /^[a-zA-Z0-9]{1,58}$/.freeze

  validate :name, :presence
  validate :name, :type, String

  @stations = []

  def initialize(name)
    @name = name.to_s
    validate!
    @trains = []
    self.class.all << self
  end

  def self.all
    @stations
  end

  def add_train(train)
    @trains << train
    puts "Accepted a #{train.type} train with number #{train.number}"
  end

  def show_all_trains
    if @trains.empty?
      puts 'No trains at the station.'
    else
      puts "Trains at #{@name} station:"
      @trains.each do |train|
        puts "Train type: #{train.type}, Number: #{train.number}, Wagons: #{train.carts}"
      end
    end
  end

  def send_train(train_number)
    target_train = @trains.find { |train| train.number == train_number }
    if target_train
      @trains.delete(target_train)
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

  # Iterate through trains on station, passing each train to a block.
  def iterate_through_trains(&block)
    @trains.each do |train|
      block.call(train)
      puts "Train number: #{train.number}, Train type: #{train.type}, Wagons: #{train.carts.length}"
    end
  end

  private

  def trains_by_type(type)
    selected_trains = @trains.select { |train| train.type == type }
    puts "Trains of type #{type} at #{@name} station:"
    selected_trains.each do |train|
      puts "Train Number: #{train.number}"
    end
    puts "Total count: #{selected_trains.count}"
    selected_trains
  end
end
