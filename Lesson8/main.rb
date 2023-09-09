# frozen_string_literal: true

require_relative 'menu'
require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'cart'
require_relative 'cart_passenger'
require_relative 'cart_cargo'
require_relative 'modules'

class Main
  def initialize
    @trains = [] # Trains
    @routes_storage = [] # Routes
    @stations = [] # Stations
    @carts = [] # Wagons
    @menu = Menu.new
  end

  def start
    loop do
      @menu.show_menu
      choice = user_choice
      action(choice)
    end
  end

  def user_choice
    gets.chomp
  end

  def action(choice)
    case choice
    when '1'
      station_and_route_management
    when '2'
      create_train
    when '3'
      wagon_management
    when '4'
      assign_route
    when '5'
      move_train
    when '6'
      show_all
    when '7'
      exit
    else
      puts 'Invalid choice. Please try again.'
    end
  end

  # Ниже этого комментария находятся методы для меню "Station & Route management".

  def station_and_route_management
    loop do
      @menu.route_menu
      sub_menu_selection = user_choice.to_i

      case sub_menu_selection
      when 1
        create_route
      when 2
        create_station
      when 3
        operate_routes
      when 4
        start
      else
        exit
      end
    end
  end

  def create_route
    puts 'Please assign departure station:'
    @stations << (first_station = Station.new(user_choice))
    puts 'Please assign final station:'
    @stations << (last_station = Station.new(user_choice))
    @routes_storage << (user_routes = Route.new(first_station, last_station))
    puts "Route #{user_routes.stations.map(&:name).join(' -> ')} has been created."
  end

  def create_station
    puts 'Please enter the name of your station:'
    @stations << Station.new(user_choice)
    puts "Station #{@stations.last.name} has been added."
  rescue StandardError => e
    puts e.message
    retry
  end

  def operate_routes
    return puts 'No routes available' if @routes_storage.empty?

    puts 'Please select a route:'
    display_routes
    route_selection = user_choice.to_i
    return unless route_selection.positive? && route_selection <= @routes_storage.size

    selected_route = @routes_storage[route_selection - 1]
    puts "Selected route: #{selected_route.stations.map(&:name).join(' -> ')}"
    operate_route_actions(selected_route)
  end

  def add_station
    puts 'Enter the intermediate station:'
    @stations << (additional_station = Station.new(user_choice))
    route.add_intermediate_station(additional_station)
    puts "Intermediate station #{additional_station.name} has been added to the route."
  end

  def delete_station
    puts 'Select the station to delete:'
    route.stations.each_with_index do |station, index|
      puts "#{index + 1} - #{station.name}"
    end
    station_selection = user_choice.to_i

    return unless station_selection >= 1 && station_selection <= route.stations.size

    selected_station = route.stations[station_selection - 1]
    route.remove_intermediate_station(selected_station.name)
    puts "Station #{selected_station.name} has been removed."
    @stations.delete(selected_station)
  end

  def operate_route_actions
    @menu.operate_route_menu
    sub_menu_selection = user_choice.to_i

    case sub_menu_selection
    when 1
      add_station

    when 2
      delete_station

    when 3
      station_and_route_management
    else
      puts 'Error: Invalid selection.'
    end
  end

  # Методы меню "Station & Route management" заканчиваются здесь.

  def create_train
    puts 'Please enter the train number:'
    number = user_choice
    @menu.create_train_menu
    user_selection = user_choice.to_i
    return if user_selection != 1 && user_selection != 2

    train = PassengerTrain.new(number) if user_selection == 1
    train = CargoTrain.new(number) if user_selection == 2
    puts "#{train.type.to_s.capitalize!} train with number #{number} was created."
    @trains << train
  rescue ArgumentError
    puts 'Wrong train number, please try again:'
    retry
  rescue StandardError => e
    puts e.message
    retry
  end

  # Ниже этого комментария находятся методы для меню "Wagon management".

  def wagon_management
    return puts 'No trains available to manage.' if @trains.empty?

    @menu.show_menu
    puts 'Please select the train for wagon management:'
    display_trains
    user_selection = user_choice.to_i
    return unless user_selection >= 1 && user_selection <= @trains.size

    selected_train = @trains[user_selection - 1]

    puts "Selected train: #{selected_train.number}"
    @menu.wagon_menu

    user_operation_selection = user_choice.to_i
    case user_operation_selection
    when 1
      create_wagon
    when 2
      attach_wagon(selected_train)
    when 3
      detach_wagon(selected_train)
    when 4
      inspect_train_wagons(selected_train)
    end
  end

  def create_wagon
    @menu.create_wagon_menu
    user_selection = user_choice.to_i
    case user_selection
    when 1
      puts 'Please set the quantity of seats:'
      wagon = CartPassenger.new(user_choice.to_i).tap(&:validate!)
      puts "Passenger wagon (seats: #{wagon.total_place}) has been created."
    when 2
      puts 'Please set the volume of the cart:'
      wagon = CartCargo.new(user_choice.to_i).tap(&:validate!)
      puts "Cargo cart (volume: #{wagon.total_place}) has been created."
    else
      puts 'Invalid selection. Please choose 1 for passenger or 2 for cargo.'
      return
    end
    @carts << wagon
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
    retry
  end

  def attach_wagon(train)
    puts 'No free wagons/carts available.' if @carts.empty?
    puts 'Please select the wagon/cart:'
    @carts.each_with_index do |cart, index|
      puts "#{index + 1}. #{cart.inspect}"
    end
    cart_index = user_choice.to_i - 1
    if cart_index.between?(0, @carts.length - 1)
      selected_cart = @carts.delete_at(cart_index)
      if selected_cart.type == train.type
        train.attach_cart(selected_cart)
      else
        puts 'Impossible to join to another type of train.'
      end
    else
      puts 'Invalid cart selection.'
    end
  end

  def detach_wagon(train)
    if train.carts.empty?
      puts 'The train has no attached wagons.'
    else
      puts "Train No.#{train.number} - Attached Carts:"
      train.carts.each_with_index do |cart, cart_num|
        puts "#{cart_num + 1} - #{cart.inspect}"
      end
      puts 'Please select a wagon to detach:'
      cart_index = user_choice.to_i - 1
      if cart_index.between?(0, train.carts.length - 1)
        selected_cart = train.carts[cart_index]
        @carts << selected_cart
        train.detach_cart(selected_cart)
      else
        puts 'Invalid selection.'
      end
    end
  end

  # Output the list of carts in the train.
  def inspect_train_wagons(selected_train)
    if selected_train.carts.empty?
      puts 'No wagons/carts attached to this train.'
    else
      selected_train.iterate_through_carts do |cart|
      end
    end
  end

  # Методы меню "Wagon management" заканчиваются здесь.

  def assign_route
    return puts 'No routes available. Please create a route first.' if @routes_storage.empty?

    puts 'Please select a route from the list:'
    display_routes
    route_selection = user_choice.to_i

    if route_selection >= 1 && route_selection <= @routes_storage.size
      selected_route = @routes_storage[route_selection - 1]

      return puts 'No trains available.' if @trains.empty?

      puts "Please assign a train for the route #{selected_route.stations.map(&:name).join(' -> ')}."
      display_trains

      train_selection = user_choice.to_i

      if train_selection >= 1 && train_selection <= @trains.size
        selected_train = @trains[train_selection - 1]
        selected_train.assign_route(selected_route)
        puts "Set route #{selected_route.stations.map(&:name).join(' -> ')} for the train №#{selected_train.number}"
      else
        puts 'Wrong selection.'
      end
    else
      puts 'Wrong selection.'
    end
  end

  # Используется для отображения поездов в методах
  def display_trains
    @trains.each_with_index do |train, index|
      puts "#{index + 1}  -  Train No.#{train.number} / type: #{train.type}"
    end
  end

  # Используется для маршрутов поездов в методах
  def display_routes
    @routes_storage.each_with_index do |route, index|
      station_names = route.stations.map(&:name).join(' -> ')
      puts "#{index + 1}  -  Route #{station_names}"
    end
  end

  def move_train
    return puts 'No trains available.' if @trains.empty?

    puts 'Please select the train to operate:'
    display_trains
    menu_selection = user_choice.to_i
    return unless (1..@trains.size).include?(menu_selection)

    selected_train = @trains[menu_selection - 1]
    puts "Selected train: #{selected_train.number}"

    @menu.move_train_menu

    user_selection = user_choice.to_i
    case user_selection
    when 1
      selected_train.move_forward
    when 2
      selected_train.move_backward
    when 3
      @menu.show_menu
    else
      exit
    end
    puts "Train #{selected_train.number} has arrived at #{selected_train.current_station.name} station."
  end

  def show_all
    return puts 'No stations and trains available.' if @stations.empty? && @trains.empty?

    @stations.each do |station|
      puts "Station: #{station.name}"
      next puts 'No trains at the station.' if station.trains.empty?

      puts 'Trains:'
      station.iterate_through_trains { |train| train.iterate_through_carts {} }
    end
  end
end

Main.new.start
