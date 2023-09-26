# frozen_string_literal: true

require_relative 'modules'

class Train
  attr_reader :number, :speed, :carts, :trains
  attr_accessor :type

  include Manufacturer
  include InstanceCounter
  NUMBER_FORMAT = /^[A-Za-z0-9]{3}-?[A-Za-z0-9]{2}$/.freeze

  def initialize(number)
    @number = number.to_s
    @type = type
    validate!
    @carts = []
    @speed = 0
    @current_station_index = nil
    @route = nil
    register_instance
  end

  def validate!
    errors = []
    errors << "Number can't be empty." if @number.nil? || number == ''
    errors << 'Invalid format.' unless @number =~ NUMBER_FORMAT
    errors << 'Type may be only passenger or cargo.' unless @type == :cargo || @type == :passenger
    raise errors.join('.') unless errors.empty?
  end

  def self.find(train_number)
    trains_find.find { |train| train.number == train_number }
  end

  def self.trains_list
    @trains_list ||= []
  end

  def accelerate(speed)
    @speed = speed
  end

  def brake
    @speed = 0
  end

  def attach_cart(cart)
    @carts << cart if @speed.zero? && cart.type == @type
    puts "#{cart.inspect} has been attached to a train."
  end

  def detach_cart(cart)
    @carts.delete(cart) if @speed.zero? && @carts.include?(cart)
    puts "#{cart.inspect} has been detached from a train."
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

  # Iterate through carts in trains, Passing each cart to a block.
  def iterate_through_carts(&block)
    @carts.each do |cart|
      block.call(cart)
      if cart.type == :passenger
        puts "Used seats: #{cart.used_place}, Free seats: #{cart.free_place}"
      else
        puts "Free volume: #{cart.free_place}, Occupied volume: #{cart.used_place}"
      end
    end
  end
end
