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
    @trains = [] #Поезда
    @routes_storage = [] #Маршруты
    @stations = [] #Станции
    @carts = [] #Вагоны
  end

  def start
    loop do
      show_menu
      choice = get_user_choice
      action(choice)
    end
  end

  def show_menu
    puts "Please select an action by number:"
    puts "1  -  Station & Route management."
    puts "2  -  Create a train."
    puts "3  -  Wagons management."
    puts "4  -  Assign route for a train."
    puts "5  -  Move train."
    puts "6  -  Show all stations and list of trains on the stations."
    puts "7  -  Exit."
  end

  def get_user_choice
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
      puts "Invalid choice. Please try again."
    end
  end

 # Ниже этого комментария находятся методы для меню "Station & Route management".

  def station_and_route_management
  
    loop do
        puts "Please select an action by number: 
        1  -  Create route. 
        2  -  Create station. 
        3  -  Operate routes.
        4  -  Return to the main menu.
        5  -  Exit."
      
        sub_menu_selection = gets.chomp.to_i
      
        case sub_menu_selection
        when 1
          create_route
        when 2
          create_station
        when 3
          operate_routes
        when 4
          start
        when 5
          exit
        else
          exit
        end
    end
  end

  def create_route
    puts "Please assign departure station:"
    first_station = Station.new(gets.chomp)
    @stations << first_station
    puts "Please assign final station:"
    last_station = Station.new(gets.chomp)
    @stations << last_station
    user_routes = Route.new(first_station, last_station)
    @routes_storage << user_routes
    puts "Route #{user_routes.stations.map(&:name).join(' -> ')} has been added."
  end

  def create_station
    begin
      puts "Please enter the name of your station:"
      @stations << Station.new(gets.chomp)
      puts "Station #{@stations.last.name} has been added."
      rescue StandardError
        puts "Wrong station name, please try again:"
        retry
      rescue => e
        puts "#{e.message}"
        retry
    end
  end

  def operate_routes
    if @routes_storage.empty?
      puts "No routes available"
      station_and_route_management
    else
      puts "Please select a route:"
      @routes_storage.each_with_index do |route, index|
        station_names = route.stations.map(&:name).join(' -> ')
        puts "#{index + 1} - #{station_names}"
      end

      route_selection = gets.chomp.to_i

      if route_selection > 0 && route_selection <= @routes_storage.size
        selected_route = @routes_storage[route_selection - 1]
        puts "Selected route: #{selected_route.stations.map(&:name).join(' -> ')}"
        operate_route_actions(selected_route)
      else
        operate_routes
      end
    end
  end
      
  def operate_route_actions(route)
    puts "Please select the required action:
    1  -  Add station.
    2  -  Remove station.
    3  -  Return."
    sub_menu_selection = gets.chomp.to_i
  
    case sub_menu_selection
    when 1
      puts "Enter the intermediate station:"
      additional_station = Station.new(gets.chomp)
      @stations << additional_station
      route.add_intermediate_station(additional_station)
      puts "Intermediate station #{additional_station.name} has been added to the route."
  
    when 2 
        puts "Select the station to delete:"
        route.stations.each_with_index do |station, index|
          puts "#{index + 1} - #{station.name}"
        end
        station_selection = gets.chomp.to_i
        
        if station_selection >= 1 && station_selection <= route.stations.size
            selected_station = route.stations[station_selection - 1]
            route.remove_intermediate_station(selected_station.name)
            puts "Station #{selected_station.name} has been removed."
            @stations.delete(selected_station)
            route.remove_intermediate_station(selected_station)
        else
          return
        end
  
    when 3
      station_and_route_management
    else
      puts "Error: Invalid selection."
    end
  end
    
 # Методы меню "Station & Route management" заканчиваются здесь. 

  def create_train
    begin
        puts "Please enter the train number:"
        number = gets.chomp
        puts "Please select the type of train:
        1  -  Passenger train
        2  -  Cargo train"
        user_selection = gets.chomp.to_i
        return if user_selection != 1 && user_selection != 2
        train = PassengerTrain.new(number) if user_selection == 1
        train = CargoTrain.new(number) if user_selection == 2
        puts "#{train.type.to_s.capitalize!} train with number #{number} was created."
        @trains << train
    rescue ArgumentError 
        puts "Wrong train number, please try again:"
        retry
      rescue => e
        puts "#{e.message}"
        retry
    end
  end
 
# Ниже этого комментария находятся методы для меню "Wagon management".

  def wagon_management

    if @trains.empty?
      puts "No trains available to manage."
      return
    end
    
    puts "Please select the train for wagon management:"
    display_trains
    user_selection = gets.chomp.to_i
    if user_selection >= 1 && user_selection <= @trains.size
        selected_train = @trains[user_selection - 1]

        puts "Selected train: #{selected_train.number}"

        puts "Please select an option to operate:
        1  -  Create wagon
        2  -  Attach wagon
        3  -  Detach wagon"

        user_operation_selection = gets.chomp.to_i
        case user_operation_selection
        when 1
            create_wagon
        when 2
            attach_wagon(selected_train)
        when 3
            detach_wagon(selected_train)
        else
            wagon_management
        end
    end
  end


  def create_wagon
    begin
      puts "Please specify the type of wagon:
      1  -  Passenger wagon
      2  -  Cargo cart"
      user_selection = gets.chomp.to_i
      case user_selection
      when 1
        puts "Please set the quantity of seats:"
        num = gets.chomp.to_i
        wagon = CartPassenger.new(num)
        puts "Passenger wagon (seats: #{num}) has been created."
      when 2
        puts "Please set the volume of the cart:"
        vol = gets.chomp.to_i
        wagon = CartCargo.new(vol)
        puts "Cargo cart (volume: #{vol}) has been created."
      else
        puts "Invalid selection. Please choose 1 for passenger or 2 for cargo."
        return
      end
      @carts << wagon
    rescue => e
      puts "An error occurred: #{e.message}"
      retry
    end
  end

  def attach_wagon(train)
    if @carts.empty?
      puts "No free wagons/carts available."
    else
      puts "Please select the wagon/cart:"
      @carts.each_with_index do |cart, index|
        puts "#{index + 1}. #{cart.inspect}"
      end
      cart_index = gets.chomp.to_i - 1
      if cart_index.between?(0, @carts.length - 1)
        selected_cart = @carts.delete_at(cart_index)
        if selected_cart.type == train.type
          train.attach_cart(selected_cart)
        else
          puts "Unable to attach to the wrong type of train."
        end
      else
        puts "Invalid cart selection."
      end
    end
  end

  def detach_wagon(train)
    if train.carts.empty?
      puts "The train has no attached wagons."
    else
      puts "Train No.#{train.number} - Attached Carts:"
      train.carts.each_with_index do |cart, cart_num|
        puts "#{cart_num + 1} - #{cart.inspect}"
      end
      puts "Please select a wagon to detach:"
      cart_index = gets.chomp.to_i - 1
      if cart_index.between?(0, train.carts.length - 1)
        selected_cart = train.carts[cart_index]
        @carts << selected_cart
        train.detach_cart(selected_cart)
      else
        puts "Invalid selection."
      end
    end
  end
  
# Методы меню "Wagon management" заканчиваются здесь.

  def assign_route
    return puts "No routes available. Please create a route first." if @routes_storage.empty?

    puts "Please select a route from the list:"
    @routes_storage.each_with_index do |route, index|
      station_names = route.stations.map(&:name).join(' -> ')
      puts "#{index + 1}  -  Route #{station_names}"
    end
    route_selection = gets.chomp.to_i

    if route_selection >= 1 && route_selection <= @routes_storage.size
      selected_route = @routes_storage[route_selection - 1]

      puts "Please assign a train for the route #{selected_route.stations.map(&:name).join(' -> ')}."
      if @trains.empty?
        puts "No trains available."
        show_menu
        return
      end

      display_trains

      train_selection = gets.chomp.to_i

      if train_selection >= 1 && train_selection <= @trains.size
        selected_train = @trains[train_selection - 1]
        selected_train.assign_route(selected_route)
        puts "Route #{selected_route.stations.map(&:name).join(' -> ')} assigned for the train No.#{selected_train.number}"
      else
        puts "Wrong selection."
      end
    else
      puts "Wrong selection."
    end
  end
  
  def display_trains # Используется для отображения поездов в методах
    @trains.each_with_index do |train, index|
        puts "#{index + 1}  -  Train No.#{train.number} / type: #{train.type}"
    end
  end

  def move_train
    return puts "No trains available." if @trains.empty?
  
    puts "Please select the train to operate:"
    display_trains
    menu_selection = gets.chomp.to_i
    return unless (1..@trains.size).include?(menu_selection)
    selected_train = @trains[menu_selection - 1]
    puts "Selected train: #{selected_train.number}"
  
    puts "Please select an option:
    1  -  Move to the next station
    2  -  Move to the previous station
    3  - Return"
  
    user_selection = gets.chomp.to_i
    case user_selection
    when 1
      selected_train.move_forward
    when 2
      selected_train.move_backward
    when 3
      show_menu
    else
      show_menu
    end
    puts "Train #{selected_train.number} has arrived at #{selected_train.current_station.name} station."
  end
  
  def show_all
    if @stations.empty? && @trains.empty?
        puts "No stations and trains available."
        show_menu
    elsif @stations.empty? && !@trains.empty?
        puts "No stations available, trains are at the depot."
    else
        @stations.each do |station|
            puts "Station: #{station.name}"
            if station.trains.empty?
                puts "  No trains at the station."
            else
                puts "  Trains:"
                station.trains.each do |train|
                    puts "Type: #{train.type}, Number: #{train.number}"
                end
          end
        end
    end
  end

end

Main.new.start